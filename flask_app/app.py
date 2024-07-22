from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

char_map = {
    'a': 'ᯀ',
    'i': 'ᯤ',
    'u': 'ᯥ',
    'e': 'ᯀᯩ',
    'o': 'ᯀᯬ',
    'ha': 'ᯂ',
    'he': 'ᯂᯩ',
    'hi': 'ᯂᯪ',
    'ho': 'ᯂᯬ',
    'hu': 'ᯂᯮ',
    'h': 'ᯂ ᯲',
    'ka': 'ᯂ',
    'ke': 'ᯂᯩ',
    'ki': 'ᯂᯪ',
    'ko': 'ᯂᯬ',
    'ku': 'ᯂᯮ',
    'k': 'ᯂ ᯲',
    'ba': 'ᯅ',
    'be': 'ᯅᯩ',
    'bi': 'ᯅᯪ',
    'bo': 'ᯅᯬ',
    'bu': 'ᯅᯮ',
    'b': 'ᯅ ᯲',
    'pa': 'ᯇ',
    'pe': 'ᯇᯩ',
    'pi': 'ᯇᯪ',
    'po': 'ᯇᯬ',
    'pu': 'ᯇᯮ',
    'p': 'ᯇ ᯲',
    'na': 'ᯉ',
    'ne': 'ᯉᯩ',
    'ni': 'ᯉᯪ',
    'no': 'ᯉᯬ',
    'nu': 'ᯉᯮ',
    'n': 'ᯉ ᯲',
    'wa': 'ᯋ',
    'we': 'ᯋᯩ',
    'wi': 'ᯋᯪ',
    'wo': 'ᯋᯬ',
    'wu': 'ᯋᯮ',
    'w': 'ᯋ ᯲',
    'ga': 'ᯎ',
    'ge': 'ᯎᯩ',
    'gi': 'ᯎᯪ',
    'go': 'ᯎᯬ',
    'gu': 'ᯎᯮ',
    'g': 'ᯎ ᯲',
    'ja': 'ᯐ',
    'je': 'ᯐᯩ',
    'ji': 'ᯐᯪ',
    'jo': 'ᯐᯬ',
    'ju': 'ᯐᯮ',
    'j': 'ᯐ ᯲',
    'da': 'ᯑ',
    'de': 'ᯑᯩ',
    'di': 'ᯑᯪ',
    'do': 'ᯑᯬ',
    'du': 'ᯑᯮ',
    'd': 'ᯑ ᯲',
    'ra': 'ᯒ',
    're': 'ᯒᯩ',
    'ri': 'ᯒᯪ',
    'ro': 'ᯒᯬ',
    'ru': 'ᯒᯮ',
    'r': 'ᯒ ᯲',
    'ma': 'ᯔ',
    'me': 'ᯔᯩ',
    'mi': 'ᯔᯪ',
    'mo': 'ᯔᯬ',
    'mu': 'ᯔᯮ',
    'm': 'ᯔ ᯲',
    'ta': 'ᯖ',
    'te': 'ᯖᯩ',
    'ti': 'ᯖᯪ',
    'to': 'ᯖᯬ',
    'tu': 'ᯖᯮ',
    't': 'ᯖ ᯲',
    'sa': 'ᯘ',
    'se': 'ᯘᯩ',
    'si': 'ᯘᯪ',
    'so': 'ᯘᯬ',
    'su': 'ᯘᯮ',
    's': 'ᯘ ᯲',
    'ya': 'ᯛ',
    'ye': 'ᯛᯩ',
    'yi': 'ᯛᯪ',
    'yo': 'ᯛᯬ',
    'yu': 'ᯛᯮ',
    'y': 'ᯛ ᯲',
    'nga': 'ᯝ',
    'nge': 'ᯝᯩ',
    'ngi': 'ᯝᯪ',
    'ngo': 'ᯝᯬ',
    'ngu': 'ᯝᯮ',
    'ng': 'ᯝ ᯲',
    'la': 'ᯞ',
    'le': 'ᯞᯩ',
    'li': 'ᯞᯪ',
    'lo': 'ᯞᯬ',
    'lu': 'ᯞᯮ',
    'l': 'ᯞ ᯲',
    'nya': 'ᯠ',
    'nye': 'ᯠᯩ',
    'nyi': 'ᯠᯪ',
    'nyo': 'ᯠᯬ',
    'nyu': 'ᯠᯮ',
    'ny': 'ᯠ ᯲',
    ' ': ' ',
}

def transliterate_batak(input_text):
    input_text = input_text.lower()  # Mengubah semua karakter menjadi huruf kecil
    tokens = []
    i = 0
    while i < len(input_text):
        found = False
        for token in sorted(char_map.keys(), key=len, reverse=True):
            if input_text[i:i+len(token)] == token:
                tokens.append(token)
                i += len(token)
                found = True
                break
        if not found:
            return f"Karakter {input_text[i]} tidak ditemukan dalam aksara Batak Toba"

    transliterated_tokens = [char_map[token] if token in char_map else token for token in tokens]
    transliterated_text = "".join(transliterated_tokens)
    return transliterated_text, tokens

@app.route('/transliterate', methods=['POST'])
def transliterate():
    data = request.get_json()
    if not data or 'text' not in data:
        return jsonify({'error': 'Teks masukan tidak ditemukan.'}), 400
    
    input_text = data['text']
    hasil_transliterasi, tokens = transliterate_batak(input_text)
    if hasil_transliterasi:
        return jsonify({'result': hasil_transliterasi, 'tokens': tokens}), 200
    else:
        return jsonify({'error': 'Karakter tidak ditemukan dalam aksara Batak Toba.'}), 400

if __name__ == '__main__':
    app.run(debug=True)

