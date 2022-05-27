/*
 * Copyright (C) 2022  walking-octopus
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * translate is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7

QtObject {
    id: lingva
    property string baseURL
    property var languages

    function translate(source, target, query) {
        const url = baseURL + "/%1/%2/%3".arg(source).arg(target).arg(encodeURIComponent(query))

        request(url).then(response => {
            const data = JSON.parse(response)

            //print(data.translation)

            output.text = data.translation
        })
        .catch(error => console.error(error))
    }

    function get_audio(lang, query) {
        const url = baseURL + "/audio/%1/%2".arg(encodeURIComponent(query)).arg(lang)
        print(url)

        request(url).then(response => {
            const data = JSON.parse(response)

            print(data.audio)
        })
    }

    function get_languages(last_source_lang, last_target_lang) {
        request(baseURL + "/languages").then(response => {
            const data = JSON.parse(response)
            languages = data.languages

            let language_names = []
            languages.forEach(i => language_names.push(i.name))
            //for(var i = 1; i <= 10; i++) {language_names.push(i)}

            source_lang.model = language_names
            language_names.shift(); target_lang.model = language_names

            target_lang.currentIndex = last_target_lang
            source_lang.currentIndex = last_source_lang
        })
    }

    function language_name_to_code(i) {
        return languages[i].code
    }

    Component.onCompleted: lingva.baseURL = preferences.baseURL
}