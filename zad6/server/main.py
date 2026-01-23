from flask import Flask, request, jsonify
import re

app = Flask(__name__)

purchased_products = []

@app.route("/payment", methods=["POST"])
def payment():
    data = request.get_json()

    blik = str(data.get("blik", ""))
    kwota = data.get("kwota")
    product = data.get("product", "Nieznany produkt")

    blik_ok = re.fullmatch(r"\d{6}", blik)
    kwota_ok = isinstance(kwota, (int, float)) and kwota > 0

    if blik_ok and kwota_ok:
        purchased_products.append({
            "product": product,
            "amount": kwota
        })

        return jsonify({
            "status": "success",
            "message": "Płatność przeszła poprawnie"
        }), 200

    return jsonify({
        "status": "error",
        "message": "Nieprawidłowy numer BLIK lub kwota"
    }), 400

@app.route("/products", methods=["GET"])
def products():
    return jsonify(purchased_products), 200

if __name__ == "__main__":
    app.run(debug=True)
