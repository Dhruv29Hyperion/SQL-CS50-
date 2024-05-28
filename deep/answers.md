# From the Deep

In this problem, you'll write freeform responses to the questions provided in the specification.

## Random Partitioning

TODO

Reasons to Adopt:

Simplicity: Random partitioning is a straightforward approach, minimizing the complexity of the distribution process. It requires minimal logic for assignment, making it easy to implement.
Uniform Load: Since observations are randomly assigned to boats, the overall load across all boats is likely to be evenly distributed, preventing bottlenecks on any specific boat.

Reasons not to Adopt:

Inefficient Queries: Querying for specific time ranges may require searching across all boats, leading to inefficiency. If AquaByte commonly collects observations during specific time intervals, this approach may not optimize query performance.
Lack of Data Locality: Observations related to a specific time period are scattered randomly across boats, potentially causing increased network traffic when querying for time-related patterns.

## Partitioning by Hour

TODO

Reasons to Adopt:

Improved Query Efficiency: Queries related to specific time ranges become more efficient, as each boat specializes in a particular time window. This reduces the need to scan all boats for relevant observations.
Enhanced Data Locality: By grouping observations based on time intervals, each boat becomes a repository for a specific subset of data, improving data locality for time-related queries.

Reasons not to Adopt:

Imbalanced Load: If AquaByte predominantly observes during specific hours, the boat responsible for that time window may experience a significantly higher load compared to others, potentially causing performance issues.
Limited Flexibility: This approach assumes a fixed partitioning strategy based on hours, which might not adapt well to changes in observation patterns or boat capacities.


## Partitioning by Hash Value

TODO

Reasons to Adopt:

Uniform Distribution: Hash partitioning ensures an even distribution of observations across all boats, preventing uneven loads on individual boats.
Flexibility: The hash function allows for a dynamic assignment of observations to boats, providing adaptability to changes in observation patterns or boat capacities.
Efficient Queries: Specific observations or time ranges can be efficiently queried by calculating the hash value for the timestamp, determining the boat responsible for that data.
Reasons not to Adopt:

Hash Function Overhead: The implementation of a hash function introduces additional computational overhead. While this overhead may be minimal, it should be considered, especially in high-throughput scenarios.
Complexity: The need for a consistent and well-distributed hash function adds complexity to the system. Implementing and maintaining a reliable hash function requires careful consideration.
