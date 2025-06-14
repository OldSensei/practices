#include <cstdint>
#include <memory>
#include <type_traits>

#include <iostream>

namespace data_struct
{
	template<typename T>
	class AVLTree
	{
	private:
		struct Node
		{
			Node() = delete;

			template<typename U>
				requires std::is_same_v<T, std::remove_reference_t<U>>
			Node(U&& data) : m_data(std::forward<U>(data)) {};

			std::unique_ptr<Node> m_left = nullptr;
			std::unique_ptr<Node> m_right = nullptr;
			Node* m_parent = nullptr;

			std::int32_t m_height = 1;
			T m_data;
		};

		friend bool operator == (const Node& l, const Node& r)
		{
			return l.m_data == r.m_data;
		}

		friend bool operator != (const Node& l, const Node& r)
		{
			return !(l.m_data == r.m_data);
		}

		friend bool operator < (const Node& l, const Node& r)
		{
			return l.m_data < r.m_data;
		}

		friend bool operator > (const Node& l, const Node& r)
		{
			return r.m_data < l.m_data;
		}

		friend bool operator <= (const Node& l, const Node& r)
		{
			return !(r.m_data < l.m_data);
		}

		friend bool operator >= (const Node& l, const Node& r)
		{
			return !(l.m_data < r.m_data);
		}

	public:

		template<typename U>
			requires std::is_same_v<T, std::remove_reference_t<U>>
		void Add(U&& data);

		bool Remove(const T& data);

		void print()
		{
			if (!m_root)
			{
				std::cout << "nil ";
			}

			printNode(m_root);
		}

	private:
		void insert(std::unique_ptr<Node>& node);
		Node* search(const T& data);
		void del(Node* node);
		void printNode(std::unique_ptr<Node>& node);

		Node* getMinimal(const std::unique_ptr<Node>& subtreeRoot);
		std::int32_t getHeight(const std::unique_ptr<Node>& node) const;
		std::int32_t getBalance(const Node& node) const;

		void rebuildTreeNodes(Node* node);
		void rebuildParentLinks(Node* oldChild, Node* newChild);

		void leftRotation(Node* node);
		void rightRotation(Node* node);
		void leftRightRotation(Node* node);
		void rightLeftRotation(Node* node);

	private:
		std::unique_ptr<Node> m_root = nullptr;
	};

	template<typename T>
	void AVLTree<T>::printNode(std::unique_ptr<Node>& node)
	{
		if (!node)
		{
			return;
		}

		printNode(node->m_left);
		std::cout << node->m_data << "(" << node->m_height << ") ";
		printNode(node->m_right);
	}

	template<typename T>
	AVLTree<T>::Node* AVLTree<T>::getMinimal(const std::unique_ptr<Node>& subtreeRoot)
	{
		Node* current = subtreeRoot.get();
		Node* result = nullptr;
		while (current)
		{
			result = current;
			current = current->m_left.get();
		}
		return result;
	}

	template<typename T>
	std::int32_t AVLTree<T>::getHeight(const std::unique_ptr<Node>& node) const
	{
		if (!node)
		{
			return 0;
		}
		return node->m_height;
	}

	template<typename T>
	std::int32_t AVLTree<T>::getBalance(const Node& node) const
	{
		return getHeight(node.m_left) - getHeight(node.m_right);
	}

	template<typename T>
	void AVLTree<T>::rebuildParentLinks(Node* parent, Node* newChild)
	{
		newChild->m_parent = parent;
		if (parent)
		{
			if (*parent > *newChild)
			{
				newChild->m_parent->m_left.release();
				newChild->m_parent->m_left.reset(newChild);
			}
			else
			{
				newChild->m_parent->m_right.release();
				newChild->m_parent->m_right.reset(newChild);
			}
		}
		else
		{
			m_root.release();
			m_root.reset(newChild);
		}
	}

	template<typename T>
	void AVLTree<T>::leftRotation(Node* node)
	{
		Node* newRoot = node->m_right.release();
		rebuildParentLinks(node->m_parent, newRoot);

		node->m_right.reset(newRoot->m_left.release());
		if (node->m_right)
		{
			node->m_right->m_parent = node;
		}

		newRoot->m_left.reset(node);
		node->m_parent = newRoot;

		node->m_height = 1 + std::max(getHeight(node->m_left), getHeight(node->m_right));
		newRoot->m_height = 1 + std::max(getHeight(newRoot->m_left), getHeight(newRoot->m_right));
	}

	template<typename T>
	void AVLTree<T>::rightRotation(Node* node)
	{
		Node* newRoot = node->m_left.release();
		rebuildParentLinks(node->m_parent, newRoot);

		node->m_left.reset(newRoot->m_right.release());
		if (node->m_left)
		{
			node->m_left->m_parent = node;
		}

		newRoot->m_right.reset(node);
		node->m_parent = newRoot;

		node->m_height = 1 + std::max(getHeight(node->m_left), getHeight(node->m_right));
		newRoot->m_height = 1 + std::max(getHeight(newRoot->m_left), getHeight(newRoot->m_right));
	}

	template<typename T>
	void AVLTree<T>::leftRightRotation(Node* node)
	{
		leftRotation(node->m_left.get());
		rightRotation(node);
	}

	template<typename T>
	void AVLTree<T>::rightLeftRotation(Node* node)
	{
		rightRotation(node->m_right.get());
		leftRotation(node);
	}

	template<typename T>
	void AVLTree<T>::rebuildTreeNodes(Node* node)
	{
		if (!node)
		{
			return;
		}

		std::int32_t balance = getBalance(*node);

		if (balance > 1 && node->m_left->m_left)
		{
			rightRotation(node);
		}
		else if (balance > 1 && node->m_left->m_right)
		{
			leftRightRotation(node);
		}
		else if (balance < -1 && node->m_right->m_right)
		{
			leftRotation(node);
		}
		else if (balance < -1 && node->m_right->m_left)
		{
			rightLeftRotation(node);
		}
	}

	template<typename T>
	void AVLTree<T>::insert(std::unique_ptr<Node>& node)
	{
		if (!m_root)
		{
			m_root = std::move(node);
			return;
		}

		Node* current = m_root.get();
		Node* last = current;

		while (current)
		{
			last = current;
			if (*node >= *current)
			{
				current = current->m_right.get();
			}
			else
			{
				current = current->m_left.get();
			}
		}

		node->m_parent = last;
		if (*node >= *last)
		{
			last->m_right = std::move(node);
		}
		else
		{
			last->m_left = std::move(node);
		}

		current = last;
		while (current)
		{
			current->m_height = 1 + std::max(getHeight(current->m_left), getHeight(current->m_right));
			rebuildTreeNodes(current);

			current = current->m_parent;
		}
	}

	template<typename T>
	AVLTree<T>::Node* AVLTree<T>::search(const T& data)
	{
		Node* current = m_root.get();
		while(current)
		{
			if (data > current->m_data)
			{
				current = current->m_right.get();
			}
			else if (data < current->m_data)
			{
				current = current->m_left.get();
			}
			else
			{
				break;
			}
		}
		return current;
	}

	template<typename T>
	void AVLTree<T>::del(Node* node)
	{
		Node* parent = node->m_parent;
		Node* heightRecalculationNode = parent;
		if (!node->m_right || !node->m_left)
		{
			Node* tmp = node->m_right ? node->m_right.get() : node->m_left.get();
			node->m_left.release();
			node->m_right.release();
			node->m_parent = nullptr;

			if (tmp)
			{
				tmp->m_parent = parent;
			}

			if (parent)
			{
				if (*parent > *node)
				{
					parent->m_left.reset(tmp);
				}
				else
				{
					parent->m_right.reset(tmp);
				}
			}
			else
			{
				m_root.reset(tmp);
				heightRecalculationNode = m_root.get();
			}
		}
		else
		{
			Node* minimalNode = getMinimal(node->m_right);
			Node* minimalNodeParent = minimalNode->m_parent;
			heightRecalculationNode = minimalNode->m_right.get();
			if (!heightRecalculationNode)
			{
				heightRecalculationNode = minimalNodeParent;
			}

			if (*minimalNodeParent > *minimalNode)
			{
				minimalNodeParent->m_left.release();
				minimalNodeParent->m_left = std::move(minimalNode->m_right);
			}
			else
			{
				minimalNodeParent->m_right.release();
				minimalNodeParent->m_right = std::move(minimalNode->m_right);
			}

			node->m_left->m_parent = minimalNode;
			node->m_right->m_parent = minimalNode;

			minimalNode->m_left = std::move(node->m_left);
			minimalNode->m_right = std::move(node->m_right);

			minimalNode->m_parent = node->m_parent;
			if (parent)
			{
				if (*parent > *node)
				{
					parent->m_left.reset(minimalNode);
				}
				else
				{
					parent->m_right.reset(minimalNode);
				}
			}
			else
			{
				m_root.reset(minimalNode);
			}
		}

		Node* current = heightRecalculationNode;
		while (current)
		{
			current->m_height = 1 + std::max(getHeight(current->m_left), getHeight(current->m_right));
			rebuildTreeNodes(current);

			current = current->m_parent;
		}

	}

	template<typename T>
	template<typename U>
		requires std::is_same_v<T, std::remove_reference_t<U>>
	void AVLTree<T>::Add(U&& data)
	{
		auto node = std::make_unique<Node>(std::forward<U>(data));
		insert(node);
	}

	template<typename T>
	bool AVLTree<T>::Remove(const T& data)
	{
		if (Node* result = search(data))
		{
			del(result);
			return true;
		}

		return false;;
	}
} // namespace data_struct
