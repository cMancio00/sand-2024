import igraph


def degree_centralization(graph: igraph.Graph, mode: str = "all") -> float:
    """
    Calculate degree centralization index of a given graph.
    The index ranges between 0 and 1.

    :param graph: igraph Graph
    :param mode: mode to calculate the degree "in", "out" or "all" Default is "all".
    :return: float with degree centralization index
    """
    if mode not in ["in", "out", "all"]:
        raise ValueError("Mode must be 'in', 'out' or 'all'")
    degrees = graph.degree(mode=mode)
    max_degree = max(degrees)
    sum_diff = sum([max_degree - degree for degree in degrees])
    max_sum_diff = len(degrees) * (len(degrees) - 1)
    return sum_diff / max_sum_diff

