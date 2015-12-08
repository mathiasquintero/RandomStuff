package pong;
import java.awt.Color;
import java.awt.Graphics;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import javax.swing.*;
public class Pong extends JFrame implements KeyListener{
    Paddle playerOne;
    Paddle playerTwo;
    Ball ball;
    public Pong(){
        this.setBackground(Color.black);
        this.setSize(800, 400);
        this.setVisible(true);
        this.setLocationRelativeTo(null);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        playerOne = new Paddle(10,150);
        playerTwo = new Paddle(this.getSize().width-10-10,150);
        ball = new Ball(this.getSize().width/2,this.getSize().height/2,5);
        this.getContentPane().add(playerOne);
        this.getContentPane().add(playerTwo);
        this.addKeyListener(this);
    }
    public void run(){
        while(playerOne.score<7 && playerTwo.score<7){
            try {
                Thread.sleep(20);
            } catch (InterruptedException ex) {}
            update();
            this.getGraphics().clearRect(0, 0, this.getSize().width, this.getSize().height);
            this.getGraphics().setColor(Color.white);
            this.getGraphics().drawLine(this.getSize().width/2, 0, this.getSize().width/2, this.getSize().height);
            ball.paint(this.getGraphics());
            playerOne.paint(this.getGraphics());
            playerTwo.paint(this.getGraphics());
        }
        if(playerOne.score==7){
            System.out.println("Player 1 WINS!");
        } else {
            System.out.println("Player 2 WINS!");
        }
        this.setVisible(false);
    }
    public void update(){
        this.requestFocusInWindow();
        ball.x+=ball.xV;
        ball.y+=ball.yV;
        if(ball.y-2*ball.radius<=10 || ball.y+2*ball.radius>=this.getSize().height){
            ball.yV=(float) (-ball.yV);
        }
        if(ball.x+2*ball.radius>=this.getSize().width){
            playerOne.score++;
            ball = new Ball(this.getSize().width/2,this.getSize().height/2,5);
        }
        if(ball.x<=0){
            playerTwo.score++;
            ball = new Ball(this.getSize().width/2,this.getSize().height/2,5);
            ball.xV*=(-1);
        }
        if(ball.x+2*ball.radius>=playerTwo.x && ball.x+2*ball.radius<playerTwo.x+playerTwo.width && ball.y<=playerTwo.y+playerTwo.height && ball.y+2*ball.radius>=playerTwo.y){
            float v = (float) ((float) Math.sqrt(ball.xV*ball.xV+ball.yV*ball.yV));
            float angle = (float) Math.tan(ball.xV/ball.yV);
            ball.xV = -(float) (v*Math.cos(angle));
            ball.yV = (float) (v*-Math.sin(angle));
        }
        if(ball.x>playerOne.x && ball.x<=playerOne.x+playerOne.width && ball.y<=playerOne.y+playerOne.height && ball.y+2*ball.radius>=playerOne.y){
            float v = (float) ((float) Math.sqrt(ball.xV*ball.xV+ball.yV*ball.yV));
            float angle = (float) Math.tan(ball.xV/ball.yV);
            ball.xV = (float) (v*Math.cos(angle));
            ball.yV = (float) (v*-Math.sin(angle));
        }
    }
    @Override
    public void keyTyped(KeyEvent e) {}
    @Override
    public void keyPressed(KeyEvent e) {
        int keyCode = e.getKeyCode();
        if(keyCode==40){
            playerTwo.y+=30;
        }
        if(e.getKeyCode()==38){
            playerTwo.y-=30;
        }
        if(keyCode==87){
            playerOne.y-=30;
        }
        if(e.getKeyCode()==83){
            playerOne.y+=30;
        }
        e.consume();
    }
    @Override
    public void keyReleased(KeyEvent e) {}
    public static class Paddle extends JComponent{
        static final int width = 10;
        static final int height = 80;
        int x;
        int y;
        int score = 0;
        public Paddle(int x, int y){
            this.x = x;
            this.y = y;
        }
        @Override
        public void paint(Graphics g){
            g.setColor(Color.white);
            g.drawRect(x, y, width, height);
        }
    }
    public static class Ball extends JComponent {
        final int radius;
        float x;
        float y;
        float xV;
        float yV;
        public Ball(float x, float y, int r){
            radius = r;
            this.x = x;
            this.y = y;
            this.xV= 3+(float) Math.random()*2;
            this.yV= (float) Math.random()*5;
        }
        @Override
        public void paint(Graphics g){
            g.setColor(Color.white);
            g.drawOval((int) x, (int) y, 2*radius, 2*radius);
        }
    }
    public static void main(String[] args) {
        new Pong().run();
    }
}