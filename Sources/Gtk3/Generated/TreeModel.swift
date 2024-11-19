import CGtk3

/// The #GtkTreeModel interface defines a generic tree interface for
/// use by the #GtkTreeView widget. It is an abstract interface, and
/// is designed to be usable with any appropriate data structure. The
/// programmer just has to implement this interface on their own data
/// type for it to be viewable by a #GtkTreeView widget.
///
/// The model is represented as a hierarchical tree of strongly-typed,
/// columned data. In other words, the model can be seen as a tree where
/// every node has different values depending on which column is being
/// queried. The type of data found in a column is determined by using
/// the GType system (ie. #G_TYPE_INT, #GTK_TYPE_BUTTON, #G_TYPE_POINTER,
/// etc). The types are homogeneous per column across all nodes. It is
/// important to note that this interface only provides a way of examining
/// a model and observing changes. The implementation of each individual
/// model decides how and if changes are made.
///
/// In order to make life simpler for programmers who do not need to
/// write their own specialized model, two generic models are provided
/// — the #GtkTreeStore and the #GtkListStore. To use these, the
/// developer simply pushes data into these models as necessary. These
/// models provide the data structure as well as all appropriate tree
/// interfaces. As a result, implementing drag and drop, sorting, and
/// storing data is trivial. For the vast majority of trees and lists,
/// these two models are sufficient.
///
/// Models are accessed on a node/column level of granularity. One can
/// query for the value of a model at a certain node and a certain
/// column on that node. There are two structures used to reference a
/// particular node in a model. They are the #GtkTreePath-struct and
/// the #GtkTreeIter-struct (“iter” is short for iterator). Most of the
/// interface consists of operations on a #GtkTreeIter-struct.
///
/// A path is essentially a potential node. It is a location on a model
/// that may or may not actually correspond to a node on a specific
/// model. The #GtkTreePath-struct can be converted into either an
/// array of unsigned integers or a string. The string form is a list
/// of numbers separated by a colon. Each number refers to the offset
/// at that level. Thus, the path `0` refers to the root
/// node and the path `2:4` refers to the fifth child of
/// the third node.
///
/// By contrast, a #GtkTreeIter-struct is a reference to a specific node on
/// a specific model. It is a generic struct with an integer and three
/// generic pointers. These are filled in by the model in a model-specific
/// way. One can convert a path to an iterator by calling
/// gtk_tree_model_get_iter(). These iterators are the primary way
/// of accessing a model and are similar to the iterators used by
/// #GtkTextBuffer. They are generally statically allocated on the
/// stack and only used for a short time. The model interface defines
/// a set of operations using them for navigating the model.
///
/// It is expected that models fill in the iterator with private data.
/// For example, the #GtkListStore model, which is internally a simple
/// linked list, stores a list node in one of the pointers. The
/// #GtkTreeModelSort stores an array and an offset in two of the
/// pointers. Additionally, there is an integer field. This field is
/// generally filled with a unique stamp per model. This stamp is for
/// catching errors resulting from using invalid iterators with a model.
///
/// The lifecycle of an iterator can be a little confusing at first.
/// Iterators are expected to always be valid for as long as the model
/// is unchanged (and doesn’t emit a signal). The model is considered
/// to own all outstanding iterators and nothing needs to be done to
/// free them from the user’s point of view. Additionally, some models
/// guarantee that an iterator is valid for as long as the node it refers
/// to is valid (most notably the #GtkTreeStore and #GtkListStore).
/// Although generally uninteresting, as one always has to allow for
/// the case where iterators do not persist beyond a signal, some very
/// important performance enhancements were made in the sort model.
/// As a result, the #GTK_TREE_MODEL_ITERS_PERSIST flag was added to
/// indicate this behavior.
///
/// To help show some common operation of a model, some examples are
/// provided. The first example shows three ways of getting the iter at
/// the location `3:2:5`. While the first method shown is
/// easier, the second is much more common, as you often get paths from
/// callbacks.
///
/// ## Acquiring a #GtkTreeIter-struct
///
/// |[<!-- language="C" -->
/// // Three ways of getting the iter pointing to the location
/// GtkTreePath *path;
/// GtkTreeIter iter;
/// GtkTreeIter parent_iter;
///
/// // get the iterator from a string
/// gtk_tree_model_get_iter_from_string (model,
/// &iter,
/// "3:2:5");
///
/// // get the iterator from a path
/// path = gtk_tree_path_new_from_string ("3:2:5");
/// gtk_tree_model_get_iter (model, &iter, path);
/// gtk_tree_path_free (path);
///
/// // walk the tree to find the iterator
/// gtk_tree_model_iter_nth_child (model, &iter,
/// NULL, 3);
/// parent_iter = iter;
/// gtk_tree_model_iter_nth_child (model, &iter,
/// &parent_iter, 2);
/// parent_iter = iter;
/// gtk_tree_model_iter_nth_child (model, &iter,
/// &parent_iter, 5);
/// ]|
///
/// This second example shows a quick way of iterating through a list
/// and getting a string and an integer from each row. The
/// populate_model() function used below is not
/// shown, as it is specific to the #GtkListStore. For information on
/// how to write such a function, see the #GtkListStore documentation.
///
/// ## Reading data from a #GtkTreeModel
///
/// |[<!-- language="C" -->
/// enum
/// {
/// STRING_COLUMN,
/// INT_COLUMN,
/// N_COLUMNS
/// };
///
/// ...
///
/// GtkTreeModel *list_store;
/// GtkTreeIter iter;
/// gboolean valid;
/// gint row_count = 0;
///
/// // make a new list_store
/// list_store = gtk_list_store_new (N_COLUMNS,
/// G_TYPE_STRING,
/// G_TYPE_INT);
///
/// // Fill the list store with data
/// populate_model (list_store);
///
/// // Get the first iter in the list, check it is valid and walk
/// // through the list, reading each row.
///
/// valid = gtk_tree_model_get_iter_first (list_store,
/// &iter);
/// while (valid)
/// {
/// gchar *str_data;
/// gint   int_data;
///
/// // Make sure you terminate calls to gtk_tree_model_get() with a “-1” value
/// gtk_tree_model_get (list_store, &iter,
/// STRING_COLUMN, &str_data,
/// INT_COLUMN, &int_data,
/// -1);
///
/// // Do something with the data
/// g_print ("Row %d: (%s,%d)\n",
/// row_count, str_data, int_data);
/// g_free (str_data);
///
/// valid = gtk_tree_model_iter_next (list_store,
/// &iter);
/// row_count++;
/// }
/// ]|
///
/// The #GtkTreeModel interface contains two methods for reference
/// counting: gtk_tree_model_ref_node() and gtk_tree_model_unref_node().
/// These two methods are optional to implement. The reference counting
/// is meant as a way for views to let models know when nodes are being
/// displayed. #GtkTreeView will take a reference on a node when it is
/// visible, which means the node is either in the toplevel or expanded.
/// Being displayed does not mean that the node is currently directly
/// visible to the user in the viewport. Based on this reference counting
/// scheme a caching model, for example, can decide whether or not to cache
/// a node based on the reference count. A file-system based model would
/// not want to keep the entire file hierarchy in memory, but just the
/// folders that are currently expanded in every current view.
///
/// When working with reference counting, the following rules must be taken
/// into account:
///
/// - Never take a reference on a node without owning a reference on its parent.
/// This means that all parent nodes of a referenced node must be referenced
/// as well.
///
/// - Outstanding references on a deleted node are not released. This is not
/// possible because the node has already been deleted by the time the
/// row-deleted signal is received.
///
/// - Models are not obligated to emit a signal on rows of which none of its
/// siblings are referenced. To phrase this differently, signals are only
/// required for levels in which nodes are referenced. For the root level
/// however, signals must be emitted at all times (however the root level
/// is always referenced when any view is attached).
public protocol TreeModel: GObjectRepresentable {

    /// This signal is emitted when a row in the model has changed.
    var rowChanged: ((Self) -> Void)? { get set }

    /// This signal is emitted when a row has been deleted.
    ///
    /// Note that no iterator is passed to the signal handler,
    /// since the row is already deleted.
    ///
    /// This should be called by models after a row has been removed.
    /// The location pointed to by @path should be the location that
    /// the row previously was at. It may not be a valid location anymore.
    var rowDeleted: ((Self) -> Void)? { get set }

    /// This signal is emitted when a row has gotten the first child
    /// row or lost its last child row.
    var rowHasChildToggled: ((Self) -> Void)? { get set }

    /// This signal is emitted when a new row has been inserted in
    /// the model.
    ///
    /// Note that the row may still be empty at this point, since
    /// it is a common pattern to first insert an empty row, and
    /// then fill it with the desired values.
    var rowInserted: ((Self) -> Void)? { get set }

    /// This signal is emitted when the children of a node in the
    /// #GtkTreeModel have been reordered.
    ///
    /// Note that this signal is not emitted
    /// when rows are reordered by DND, since this is implemented
    /// by removing and then reinserting the row.
    var rowsReordered: ((Self) -> Void)? { get set }
}
