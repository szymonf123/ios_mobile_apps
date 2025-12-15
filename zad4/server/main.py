from flask import Flask, jsonify

app = Flask(__name__)

categories = [
    {"id": 1, "name": "Elektronika"},
    {"id": 2, "name": "Książki"},
    {"id": 3, "name": "Ubrania"}
]

products = [
    {"id": 1, "name": "Laptop", "category_id": 1, "price": 3500},
    {"id": 2, "name": "Smartfon", "category_id": 1, "price": 2500},
    {"id": 3, "name": "Python od podstaw", "category_id": 2, "price": 79},
    {"id": 4, "name": "Koszulka", "category_id": 3, "price": 49}
]

cart = [
    {"id": 1, "product_id": 1, "quantity": 1, "phone_number": "123456789", "address": "Kraków, Łojasiewicza 11"},
    {"id": 2, "product_id": 2, "quantity": 1, "phone_number": "123400789", "address": "Kraków, Łojasiewicza 16"},
    {"id": 3, "product_id": 4, "quantity": 2, "phone_number": "199400789", "address": "Warszawa, Konna 16"},
    {"id": 4, "product_id": 1, "quantity": 3, "phone_number": "199400154", "address": "Wadowice, Fatimska 4A"},
]

@app.route("/categories", methods=["GET"])
def get_categories():
    return jsonify(categories)

@app.route("/products", methods=["GET"])
def get_products():
    return jsonify(products)

@app.route("/cart", methods=["GET"])
def get_cart():
    return jsonify(cart)

@app.route("/products/<int:category_id>", methods=["GET"])
def get_products_by_category(category_id):
    filtered = [p for p in products if p["category_id"] == category_id]
    return jsonify(filtered)

if __name__ == "__main__":
    app.run(debug=True)

