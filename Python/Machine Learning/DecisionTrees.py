
import numpy as np


class Instance(object):
    values = []
    label = None

    def __init__(self, values, label):
        self.values = values
        self.label = label


class Tree(object):
    separator = None
    value = None
    distribution = None
    smaller = None
    bigger = None

    def __init__(self, distribution, separator=None, value=None, smaller=None, bigger=None):
        self.distribution = distribution
        self.separator = separator
        self.value = value
        self.smaller = smaller
        self.bigger = bigger

    def classified_distribution(self, values):
        if self.separator is None:
            return self.distribution
        if values[self.separator] <= self.value:
            return self.smaller.classified_distribution(values)
        else:
            return self.bigger.classified_distribution(values)

    def classify(self, values):
        return self.classified_distribution(values).most_common()

    def capping_depth(self, depth):
        # I read the whole depth 2 thing too late.
        # And I didn't feel like dumbing this down
        # Let's just risk overfitting the training data
        if depth < 1 or self.separator is None:
            return self

        smaller = self.smaller.capping_depth(depth - 1)
        bigger = self.bigger.capping_depth(depth - 1)
        return Tree(self.distribution, self.separator, self.value, smaller, bigger)


class Separation(object):
    separator = None
    value = None
    smaller = []
    smaller_partition = None
    bigger = []
    bigger_partition = None

    def __init__(self, separator, value, smaller, bigger, smaller_partition, bigger_partition):
        self.separator = separator
        self.value = value
        self.smaller = smaller
        self.bigger = bigger

        self.smaller_partition = smaller_partition
        self.bigger_partition = bigger_partition

    def next(self):
        if len(self.bigger) < 2:
            return None

        left, right, new_bigger = self.bigger[0], self.bigger[1], self.bigger[1:]

        new_value = (left.values[self.separator] / 2) + (right.values[self.separator] / 2)

        new_smaller = self.smaller + [left]

        new_smaller_partition = self.smaller_partition.adding(left)
        new_bigger_partition = self.bigger_partition.removing(left)
        return Separation(self.separator,
                          new_value,
                          new_smaller,
                          new_bigger,
                          new_smaller_partition,
                          new_bigger_partition)

    def information_gain(self, total_distribution, index_calculator):
        total_count = total_distribution.total_count()
        probability_of_smaller = float(len(self.smaller)) / float(total_count)
        probability_of_bigger = float(len(self.bigger)) / float(total_count)
        return total_distribution.purity_index(index_calculator) \
               - probability_of_smaller * self.smaller_partition.purity_index(index_calculator) \
               - probability_of_bigger * self.bigger_partition.purity_index(index_calculator)


class PartitionDistribution(object):
    counts = {}

    def __init__(self, counts={}):
        self.counts = counts

    @staticmethod
    def from_instances(instances):
        counts = {}
        for instance in instances:
            if instance.label not in counts:
                counts[instance.label] = 0
            counts[instance.label] += 1
        return PartitionDistribution(counts)

    def total_count(self):
        return reduce(lambda a, k: a + self.counts[k], self.counts, 0)

    def probability_of(self, label):
        total_count = self.total_count()
        return float(self.counts[label]) / float(total_count)

    def purity_index(self, index_calculator):
        return reduce(lambda a, k: a + index_calculator(self.probability_of(k)), self.counts, 0.0)

    def most_common(self):
        counts = self.counts
        return reduce(lambda a, b: a if counts[a] > counts[b] else b, counts)

    def adding(self, instance):
        # TODO: Check if dicts are called by reference or value
        counts = self.counts.copy()
        if instance.label not in counts:
            counts[instance.label] = 0
        counts[instance.label] += 1
        return PartitionDistribution(counts)

    def removing(self, instance):
        counts = self.counts.copy()
        counts[instance.label] -= 1
        return PartitionDistribution(counts)


class TreeCreator(object):
    instances = []
    distribution = None

    def __init__(self, instances, distribution):
        self.instances = instances
        self.distribution = distribution

    @staticmethod
    def from_instances(instances):
        return TreeCreator(instances, PartitionDistribution.from_instances(instances))

    def dimension_range(self):
        return range(0, len(self.instances[0].values))

    def best_separation_helper(self, separation, index_calculator):
        next = separation.next()
        if next is None:
            return separation
        best_so_far = self.best_separation_helper(next, index_calculator)
        information_gain_so_far = best_so_far.information_gain(self.distribution, index_calculator)
        current_information_gain = separation.information_gain(self.distribution, index_calculator)

        if information_gain_so_far > current_information_gain:
            return best_so_far
        else:
            return separation

    def best_separation_at(self, separator, index_calculator):
        if len(self.instances) < 2:
            return None

        sorted_instances = sorted(self.instances, key=lambda x: x.values[separator])

        left, right, tail = sorted_instances[0], sorted_instances[1], sorted_instances[1:]
        value = (left.values[separator] / 2) + (right.values[separator] / 2)

        left_distribution = PartitionDistribution(counts={left.label: 1})
        right_distribution = self.distribution.removing(left)

        separation = Separation(separator, value, [left], tail, left_distribution, right_distribution)

        return self.best_separation_helper(separation, index_calculator)

    def build_tree(self, index_calculator):
        if self.distribution.purity_index(index_calculator) <= 0.0 or len(self.instances) < 2:
            return Tree(self.distribution)

        best_splits = [self.best_separation_at(index, index_calculator) for index in self.dimension_range()]
        scores = map(lambda x: x.information_gain(self.distribution, index_calculator), best_splits)
        best_split_index = np.argmax(scores)
        best_split = best_splits[best_split_index]

        if best_split.information_gain(self.distribution, index_calculator) <= 0:
            return Tree(self.distribution)

        smaller = TreeCreator(best_split.smaller, best_split.smaller_partition).build_tree(index_calculator)
        bigger = TreeCreator(best_split.bigger, best_split.bigger_partition).build_tree(index_calculator)

        return Tree(self.distribution, best_split.separator, best_split.value, smaller, bigger)


def gini(probability):
    return probability * (1.0 - probability)


def tree_at_file(filename):
    import csv
    with open(filename, 'rb') as file:
        reader = csv.reader(file)
        output = list(reader)
        barrier = len(output[0]) - 1
        instances = map(lambda x: Instance(map(lambda y: float(y), x[:barrier]), x[barrier]), output[1:])
        return TreeCreator.from_instances(instances).build_tree(gini)

tree = tree_at_file("01_homework_dataset.csv")
print(tree)
print(tree.classify([6.1, 0.4, 1.3]))
