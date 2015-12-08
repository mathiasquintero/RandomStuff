package main;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.Reader;
import java.util.Properties;
import java.util.Random;
import javax.swing.JFrame;
public class Game extends JFrame implements KeyListener{ // To write less code, the same class listens for key commands
    public int highScore;
    public String saveFile;
    public boolean lost(){
        if(game[0][0]==null || game[3][3]==null){
            return false;
        }
        for(int x = 0; x<3;x++){
            for(int y = 0; y<3; y++){
                if(game[x][y+1]==null || game[x][y].joinable(game[x][y+1])){ //Can the block move down?
                    return false;
                }
                if(game[x+1][y]==null || game[x][y].joinable(game[x+1][y])){    //Can the block move to the right?
                    return false;
                }
            }
        }
        return true;
    }
    public Game(int width, String s){
        this.setSize(width,width+75);
        this.setVisible(true);
        saveFile = s;
        try(Reader reader = new FileReader(s);){
            Properties scoreBoard = new Properties();
            scoreBoard.load(reader);
            highScore = Integer.parseInt(scoreBoard.getProperty("0"));
        } catch(Exception e){
            highScore = 0;
        }
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        game = new Number[4][4];
        insertNewNumber();
        insertNewNumber();
        sizeOfNumber = width/4;
        print();
        print();
        this.addKeyListener(this);
    }
    private int sizeOfNumber;
    private void insertNewNumber(){
        while(!lost()){
            int rX = new Random().nextInt(4);
            int rY = new Random().nextInt(4);
            int r = new Random().nextInt(10);
            if(game[rX][rY]==null){
                if(r<9){
                    game[rX][rY] = new Number(); 
                } else {
                    game[rX][rY] = new Number(4); 
                }
                return;
            }
        }
    }
    private void print(){
        this.getGraphics().clearRect(0, 0, sizeOfNumber*4, sizeOfNumber*4+75);
        this.getGraphics().drawString("Score: " + Number.score,25, 50);
        this.getGraphics().drawString("Highest Score: " + highScore,sizeOfNumber*3, 50);
        for(int x=0;x<4;x++){
            for(int y=0;y<4;y++){
                if(game[x][y]!=null){
                    int dX = x*sizeOfNumber;
                    int dY = y*sizeOfNumber+75;
                    this.getGraphics().drawRect(dX, dY, sizeOfNumber, sizeOfNumber);
                    this.getGraphics().drawString(game[x][y].number + "", dX+sizeOfNumber/2, dY+sizeOfNumber/2);
                }
            }
        }
    }
    public Number[][] game;
    public boolean equals(Number[][] prev){
        
        //Check if array stayed the same, to detirmine whether or not to put new Number.
        
        //Fixed Bug: Without this, eventually you would have the field full, but still have moves, but insertnewNumber would be in Loop
        
        for(int i=0;i<4;i++){
            for(int j=0;j<4;j++){
                if(game[i][j]==null){
                    if(prev[i][j]!=null){
                        return false;
                    }
                } else {
                    if(prev[i][j]==null){
                        return false;
                    } else {
                        if(prev[i][j].number!=game[i][j].number){
                            return false;
                        }
                    }
                }
            }
        }
        return true;
    }
    @Override
    public void keyTyped(KeyEvent e) {}
    @Override
    public void keyReleased(KeyEvent e) {}
    @Override
    public void keyPressed(KeyEvent e) {
        Number[][] prev = new Number[4][4];
        for(int i=0;i<4;i++){
            for(int j=0;j<4;j++){
                if(game[i][j]!=null){
                    prev[i][j] = game[i][j].clone();
                }
            }
        }
        if(e.getKeyCode()==40){
            goDown();
        }
        if(e.getKeyCode()==38){
            goUp();
        }
        if(e.getKeyCode()==37){
            goLeft();
        }
        if(e.getKeyCode()==39){
            goRight();
        }
        print();
        try {
            Thread.sleep(50); //Effect
        } catch (InterruptedException ex) {}
        if(highScore<Number.score){
            highScore = Number.score;
            try(FileOutputStream stream = new FileOutputStream(saveFile)){
                Properties saving = new Properties();
                saving.setProperty("0", "" + highScore);
                saving.store(stream, "");
            } catch (Exception ex) {}
        }
        if(!equals(prev)){
            insertNewNumber();
            print();
        }
        if(lost()){
            this.removeKeyListener(this);
            try {
                Thread.sleep(500);
            } catch (InterruptedException ex) {}
            this.getGraphics().clearRect(0, 75, sizeOfNumber*4, sizeOfNumber*4);
            this.getGraphics().drawString("GAME OVER", 2*sizeOfNumber, 2*sizeOfNumber);
        }
    }
    public void goRight(){
        for(int y = 0;y<4;y++){
            for(int x = 3;x>=0;x--){
                if(game[x][y]!=null){
                    Number n = getLeft(x,y);
                    if(n!=null && game[x][y].joinable(n)){
                        game[x][y].join(n);
                        game[leftMovable(x,y)-1][y] = null;
                    }
                }
            }
        }
        for(int y = 0;y<4;y++){
            for(int x = 3;x>=0;x--){
                if(game[x][y]!=null){
                    Number n = game[x][y].clone();
                    game[x][y] = null;
                    game[rightMovable(x,y)][y] = n;
                }
            }
        }
    }
    public Number getLeft(int x, int y){
        Number n = null;
        for(int i=0;i<x;i++){
            if(game[i][y]!=null){
                n = game[i][y];
            }
        }
        return n;
    }
    public int rightMovable(int x, int y){
        int result = x;
        for(int i=x+1;i<4;i++){
            if(game[i][y]!=null){
                return result;
            }
            result = i;
        }
        return result;
    }
    public void goLeft(){
        
        //Todos a la izquierda
        
        for(int y = 0;y<4;y++){
            for(int x = 0;x<4;x++){
                if(game[x][y]!=null){
                    Number n = getRight(x,y);
                    if(n!=null && game[x][y].joinable(n)){
                        game[x][y].join(n);
                        game[rightMovable(x,y)+1][y] = null;
                    }
                }
            }
        }
        for(int x = 0;x<4;x++){
            for(int y = 0;y<4;y++){
                if(game[x][y]!=null){
                    Number n = game[x][y].clone();
                    game[x][y] = null;
                    game[leftMovable(x,y)][y] = n;
                }
            }
        }
    }
    public Number getRight(int x,int y){
        
        // Retorna primer Elemento que se encuentre a la derecha
        
        Number n = null;
        for(int i=3;i>x;i--){
            if(game[i][y]!=null){
                n = game[i][y];
            }
        }
        return n;
    }
    public int leftMovable(int x, int y){
        
        //Retorna índice de último lugar libre al que se pude mover. 
        
        int result = x;
        for(int i=x-1;i>=0;i--){
            if(game[i][y]!=null){
                return result;
            }
            result = i;
        }
        return result;
    }
    public void goUp(){
        for(int x = 0;x<4;x++){
            for(int y = 0;y<4;y++){
                if(game[x][y]!=null){
                    Number n = getDown(x,y);
                    if(n!=null && game[x][y].joinable(n)){
                        game[x][y].join(n);
                        game[x][downMovable(x,y)+1] = null;
                    }
                }
            }
        }
        for(int x = 0;x<4;x++){
            for(int y = 0;y<4;y++){
                if(game[x][y]!=null){
                    Number n = game[x][y].clone();
                    game[x][y] = null;
                    game[x][upMovable(x,y)] = n;
                }
            }
        }
    }
    public Number getDown(int x, int y){
        Number n = null;
        for(int i=3;i>y;i--){
            if(game[x][i]!=null){
                n = game[x][i];
            }
        }
        return n;
    }
    public int upMovable(int x, int y){
        int result = y;
        for(int i=y-1;i>=0;i--){
            if(game[x][i]!=null){
                return result;
            }
            result = i;
        }
        return result;
    }
    public void goDown(){
        for(int x = 0;x<4;x++){
            for(int y = 3;y>=0;y--){
                if(game[x][y]!=null){
                    Number n = getUp(x,y);
                    if(n!=null && game[x][y].joinable(n)){
                        game[x][y].join(n);
                        game[x][upMovable(x,y)-1] = null;
                    }
                }
            }
        }
        for(int x = 0;x<4;x++){
            for(int y = 3;y>=0;y--){
                if(game[x][y]!=null){
                    Number n = game[x][y].clone();  //Ensure transmission of value not referenz
                    game[x][y] = null;
                    game[x][downMovable(x,y)] = n;
                }
            }
        }
    }
    public Number getUp(int x, int y){
        Number n = null;
        for(int i=0;i<y;i++){
            if(game[x][i]!=null){
                n = game[x][i];
            }
        }
        return n;
    }
    public int downMovable(int x, int y){
        int result = y;
        for(int i=y+1;i<4;i++){
            if(game[x][i]!=null){
                return result;
            }
            result = i;
        }
        return result;
    }
    public static class Number{
        public static int score;
        private int number;
        public boolean joinable(Number n){
            return n.number == number;
        }
        public Number(){
            number = 2;
        }
        public Number(int n){
            number = n;
        }
        public void join(Number n){
            number*=2;
            score+=number;
            n = null;
        }
        @Override
        public Number clone(){
            Number n = new Number();
            n.number = number;
            return n;
        }
    }
    public static void main(String[] args){
        new Game(600,"score.properties");
    }
}