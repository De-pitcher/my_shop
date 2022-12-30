import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../utils/utils.dart';

const title = 'title';
const price = 'price';
const description = 'description';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  late Product _editedProduct;
  var _initValue = {
    title: '',
    description: '',
    price: '',
  };
  var _isInit = false;
  var _isLoading = false;

  @override
  void initState() {
    //! The _imageUrlFocusNode was added to update the imageUrl preview when the
    //! on the TextFormField has been lost
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      String productId = '';
      final fetchedIdObject = ModalRoute.of(context)!.settings.arguments;
      if (fetchedIdObject != null) productId = fetchedIdObject as String;
      if (productId.isNotEmpty) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValue = {
          title: _editedProduct.title,
          description: _editedProduct.description,
          price: _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      } else {
        _editedProduct = Product(
          id: '',
          title: '',
          description: '',
          price: 0,
          imageUrl: '',
        );
      }
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //! The _imageUrlFocusNode is disposed first to avoid memory leaks
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  /// Rebuilds the UI when the [FocusNode] of the image URL has lost focus
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https'))) {
        return;
      }
    }
    setState(() {});
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id.isNotEmpty) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await customDialog(
            context: context,
            title: 'An error occurred!',
            msg: 'Something went wrong',
            isConfirmedHandler: () {
              Navigator.of(context).pop();
            });
      } finally {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () => _saveForm(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue[title],
                      decoration: const InputDecoration(hintText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = _editedProduct.copyWith(title: value);
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue[price],
                      decoration: const InputDecoration(hintText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter a value';
                        } else if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        } else if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _editedProduct = _editedProduct.copyWith(
                          price: double.parse(value!),
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue[description],
                      decoration:
                          const InputDecoration(hintText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter a description';
                        } else if (value.length < 10) {
                          return 'Should be at least 10 characters long';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct =
                            _editedProduct.copyWith(description: value);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 8),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imageUrlController,
                            decoration:
                                const InputDecoration(labelText: 'Input URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (value) {
                              if (value == null) {
                                return 'Please enter an image URL';
                              } else if (!value.startsWith('http') ||
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL';
                              }
                              //  else if (!value.endsWith('.png') ||
                              //     !value.endsWith('.jpg') ||
                              //     !value.endsWith('jpeg')) {
                              //   return 'Please enter a valid URL';
                              // }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct =
                                  _editedProduct.copyWith(imageUrl: value);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
