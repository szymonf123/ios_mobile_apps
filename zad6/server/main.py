from flask import Flask, request, jsonify
import re

app = Flask(__name__)

@app.route("/payment", methods=["POST"])
def payment():
    data = request.get_json()

    blik = str(data.get("blik", ""))
    kwota = data.get("kwota")

    # Walidacja BLIK: dokładnie 6 cyfr
    blik_ok = re.fullmatch(r"\d{6}", blik)

    # Walidacja kwoty: liczba dodatnia
    kwota_ok = isinstance(kwota, (int, float)) and kwota > 0

    if blik_ok and kwota_ok:
        return jsonify({
            "status": "success",
            "message": "Płatność przeszła poprawnie"
        }), 200
    else:
        return jsonify({
            "status": "error",
            "message": "Nieprawidłowy numer BLIK lub kwota"
        }), 400


if __name__ == "__main__":
    app.run(debug=True)
