<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Subject</title>
    <jsp:include page="import.jsp"/>
    <script data-src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script>

        $(function () {
//Живой поиск
            $('.searchInput').bind("change keyup input click", function () {
                if (this.value.length >= 2) {
                    $.ajax({
                        url: "/partyFind/" + this.value, //Путь к обработчику
                        type: 'get',
                        cache: false,
                        success: function (data) {
                            $(".searchResult").html(data).fadeIn(); //Выводим полученые данные в списке
                            for (let i = 0; i < data.length; i++) {
                                //$('ul').append('<li id="' + data[i].name + "' value='" + JSON.stringify(data[i]) + "'>" + data[i].name + "</li>");
                                $('ul').append("<li id='" + data[i].name + "' data-attr='" + JSON.stringify(data[i]) + "'> " + data[i].name + "</li>");
                            }
                        }
                    })
                }
            })

            $(".searchResult").hover(function () {
                $(".searchInput").blur(); //Убираем фокус с input
            })

//При выборе результата поиска, прячем список и заносим выбранный результат в input
            $(".searchResult").on("click", "li", function () {

                $(".searchInput").text($("#" + $(this).text().trim()).attr('data-attr'));
                $(".searchInput").val($(this).text().trim())
                $(".searchResult").fadeOut();
            })
        })


        function showAllSubject() {
            $.get("/getAllSubject", function (data) {
                var arr = [];
                for (let i = 0; i < data.length; i++) {
                    arr.push({
                        "DT_RowId": data[i].id,
                        "name": data[i].name,
                        "party": data[i].party.name,
                        "studyingtime": data[i].studyingtime,
                        "ChangeButton": '<button type="button" class="imgButton" onclick="showOneSubject(' + data[i].id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                        "DeleteButton": '<a class="ssilka"href="/DeleteSubject/' + data[i].id + '">Удалить предмет</a>'
                    });
                }
                var table = $('#myTable').DataTable({
                    "columns": [
                        {
                            "title": "Название предмета", "data": "name", "visible": true,
                        },
                        {
                            "title": "Название группы", "data": "party", "visible": true,
                        },
                        {
                            "title": "Время обучения", "data": "studyingtime", "visible": true,
                        },
                        {
                            "title": "Кнопка изменения", "data": "ChangeButton", "visible": true,
                        },
                        {
                            "title": "Кнопка удаления", "data": "DeleteButton", "visible": true,
                        }
                    ], "language": language(),
                    data: arr
                });
            });
        }

        $(document).ready(function () {
            $("#subjectForm").css("display", "none");
            showAllSubject();
            $("#subjectForm").on('submit', function (e) {
                e.preventDefault();
                $("#span_name").text("");
                if ($("#subjectForm").valid()) {
                    $.ajax({
                        type: 'POST',
                        url: "/addSubject",
                        contentType: 'application/json; charset=utf-8',
                        data: JSON.stringify({
                            id: $("#id").val(),
                            name: $("#name").val(),
                            party: JSON.parse($(".searchInput").text()),
                            studyingtime: $("#studyingtime").val()
                        }),
                        dataType: 'json',
                        async: true
                    }).done(function (data) {
                        var table = $('#myTable').DataTable();
                        $("#subjectForm").css("display", "none");
                        if ($("#" + data.id + "").length) {
                            table.row($("#" + data.id + "")).remove().draw();
                            table.row.add({
                                "DT_RowId": data.id,
                                "name": data.name,
                                "party": data.party.name,
                                "studyingtime": data.studyingtime,
                                "ChangeButton": '<button type="button" class="imgButton" onclick="showOneSubject(' + data.id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                                "DeleteButton": '<a class="ssilka"href="/DeleteSubject/' + data.id + '">Удалить предмет</a>'
                            }).draw();

                        } else {
                            table.row.add({
                                "DT_RowId": data.id,
                                "name": data.name,
                                "party": data.party.name,
                                "studyingtime": data.studyingtime,
                                "ChangeButton": '<button type="button" class="imgButton" onclick="showOneSubject(' + data.id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                                "DeleteButton": '<a class="ssilka"href="/DeleteSubject/' + data.id + '">Удалить предмет</a>'
                            }).draw()
                        }


                    }).fail(function (data) {
                        if (data.status == 404) {
                            $("#span_name").text("Название должно быть уникальным");
                        }
                    });
                }
            });


        });


        function send() {
            //document.getElementById('subjectForm').removeAttribute("class");
            $("#id").val('');
            $("#name").val('');
            $("#studyingtime").val('');
            $('.searchInput').val('');
            $("#subjectForm").css("display", "");
        }

        $.validator.addMethod('symbols', function (value, element) {
            return value.match(new RegExp("^" + "[А-Яа-яЁё ]" + "+$"));
        }, "Здесь должны быть только русские символы");
        $(function () {
            $("#subjectForm").validate
            ({
                rules: {
                    name: {
                        required: true,
                        symbols: true,
                        minlength: 2

                    },
                    studyingtime: {
                        required: true,
                        number: true,
                        min: 10,
                        max: 250
                    },
                    referal:{
                        required:true
                    }
                },
                messages: {
                    name: {
                        required: 'Это поле не должно быть пустым',
                        minlength: 'Название предмета должно содержать больше 2 символов'
                    },
                    studyingtime: {
                        required: 'Это поле не должно быть пустым',
                        number: 'Здесь не может быть символов',
                        min: 'Минимальное число 10 для времени обчуения',
                        max: 'Максимальное число 250 для времени обчуения'
                    },
                    referal: {
                        required:"Необходимо выбрать группу"
                    }
                },
                errorPlacement: function (error, element) {
                    if (element.attr("name") == "referal")
                        $("#spanReferal").text(error.text());
                    if (element.attr("name") == "name")
                        $("#spanName").text(error.text());
                    if (element.attr("name") == "studyingtime")
                        $("#spanStudyingtime").text(error.text());

                }
            });
        })


        function showOneSubject(id) {
            $.get('/getOneSubject/' + id, function (data) {
                $("#id").val(id);
                $("#name").val(data.name);
                $("#studyingtime").val(data.studyingtime);
                //$('#party option:contains("' + data.party.name + '")').prop('selected', true);
                $('.searchInput').text(JSON.stringify(data.party))
                $('.searchInput').val(data.party.name)
                $("#subjectForm").css("display", "");
                //document.getElementById('subjectForm').removeAttribute("class");
            });
        }

        function hide() {
            //document.getElementById('subjectForm').classList.add('visible');
            $("#subjectForm").css("display", "none");
        }
    </script>
</head>
<body>
<div class="size1 container">
    <jsp:include page="header.jsp"/>

    <div class="roboto container">
        <div class="size2 container">
            <form id="subjectForm" class="form-horizontal rounded rounded-3 border border-3 p-2 border-secondary">


                <input type='hidden' name='id' id='id'/>

                <div class="form-group">
                    <label class="control-label">Название предмета</label>
                    <input type='text' name='name' id='name' class="form-control"/>
                    <span id="span_name"></span>
                    <span id="spanName"></span>
                </div>

                <div class="form-group">
                    <label class="control-label">Кол-во занятий</label>
                    <input type='number' name='studyingtime' id='studyingtime' class="form-control"/></div>
                <span id="spanStudyingtime"></span>
                <div class="form-group">
                    <p>Поиск по группам:</p>
                    <input ENGINE="text" name='referal' placeholder="Живой поиск" value='' class="searchInput"
                           autocomplete="off">
                    <span id="spanReferal"></span>
                    <ul class="searchResult"></ul>
                </div>
                <div class="form-group">
                    <img class="icon" alt="logo_1" onclick="hide()" src="/resources/image/back.png">
                    <button type="button " class="imgButton"><img class="icon" alt="logo_1"
                                                                  src="/resources/image/disc.png">
                    </button>
                </div>
            </form>


            <button type="button" onclick="send()" class="imgButton"><img class="icon" alt="logo_1"
                                                                          src="/resources/image/plus.png"></button>
            <table id='myTable' class="table table-bordered table-striped border-dark border border-2 table-hover">
                <thead>
                <th>Название предмета</th>
                <th>Название группы</th>
                <th>Время обучения</th>
                <th>Кнопка изменения</th>
                <th>Кнопка удаления</th>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
    <div class=" size2">

    </div>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>