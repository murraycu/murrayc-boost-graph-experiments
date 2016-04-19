#include <cstdlib>
#include <boost/timer/timer.hpp>

#include <boost/graph/vector_as_graph.hpp>
#include <boost/graph/topological_sort.hpp>

#include <deque>
#include <vector>
#include <list>
#include <iostream>

int main()
{
  const char *tasks[] = {
    "pick up kids from school",
    "buy groceries (and snacks)",
    "get cash at ATM",
    "drop off kids at soccer practice",
    "cook dinner",
    "pick up kids from soccer",
    "eat dinner"
  };

  std::vector<std::list<int>> g = {
    {3},
    {3, 4},
    {1},
    {5},
    {6},
    {6},
    {}};

  std::deque<int> topo_order;

  topological_sort(g,
    std::front_inserter(topo_order),
    boost::vertex_index_map(boost::identity_property_map()));

  for (const auto index : topo_order)
  {
    std::cout << tasks[index] << std::endl;
  }

  return EXIT_SUCCESS;
}
