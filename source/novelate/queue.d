/**
* Copyright © Novelate 2020
* License: MIT (https://github.com/Novelate/NovelateEngine/blob/master/LICENSE)
* Author: Jacob Jensen (bausshf)
* Website: https://novelate.com/
* ------
* Novelate is a free and open-source visual novel engine and framework written in the D programming language.
* It can be used freely for both personal and commercial projects.
* ------
* Module Description:
* This module is a wrapper around a simple queue.
*/
module novelate.queue;

/// A simple queue wrapper around a dynamic array.
final class Queue(T)
{
  private:
  /// The items of the queue.
  T[] _items;

  public:
  final:
  /// Creates a new queue.
  this()
  {
    _items = [];
  }

  @property
  {
    /// Gets the length of the queue.
    size_t length() { return _items ? _items.length : 0; }
  }

  /**
  * Enqueues an item.
  * Params:
  *   item = The item to enqueue.
  */
  void enqueue(T item)
  {
    _items ~= item;
  }

  /**
  * Peeks within the queue for the current front item. Use has() before calling this.
  * Returns:
  *   The current front item.
  */
  T peek()
  {
    auto item = _items[0];

    return item;
  }

  /**
  * Retrieves and removes the front item from the queue. Use has() before calling this.
  * Returns:
  *   The front item of the queue.
  */
  T dequeue()
  {
    auto item = _items[0];

    if (_items.length > 1)
    {
      _items = _items[1 .. $];
    }
    else
    {
      _items = [];
    }

    return item;
  }

  /**
  * Checks whether the queue has any items or not.
  * Returns:
  *   True if the queue has any items, false otherwise.
  */
  bool has()
  {
    return _items && _items.length;
  }
}
