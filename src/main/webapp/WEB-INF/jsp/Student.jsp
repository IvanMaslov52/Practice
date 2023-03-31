<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Student</title>
    <jsp:include page="import.jsp"/>


    <link rel="canonical" href="https://mdbootstrap.com/docs/b4/jquery/forms/date-picker/">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src = "/resources/js/datepicker-ru.js" >
    </script>


    <script>

        $(function () {
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


        $(function () {

            $("#bornDate").datepicker({dateFormat: 'dd/mm/yy'});
            $("#bornDate").datepicker($.datepicker.regional[ "ru" ] );

        });
        $.validator.addMethod('symbols', function (value, element) {
            return value.match(new RegExp("^" + "[А-Яа-яЁё ]" + "+$"));
        }, "Здесь должны быть только русские символы");

        $(function () {
            $("#studentForm").validate
            ({
                rules: {
                    fio: {
                        required: true,
                        symbols: true,
                        minlength: 4
                    },
                    sticket: {
                        required: true,
                        number: true,
                        min: 10000000,
                        max: 99999999
                    },
                    bornDate: {
                        required: true
                    }
                },
                messages: {
                    sticket: {
                        required: 'Это поле не должно быть пустым',
                        min: 'Минимальное число 10000000 для билета',
                        max: 'Максимальное число 99999999 для билета'
                    },
                    fio: {
                        required: 'Это поле не должно быть пустым',
                        number: 'Здесь не может быть символов',
                        minlength: 'Здесь не может быть меньше 4 символов'
                    },
                    bornDate: {
                        required: "Это поле не должно быть пустым"
                    }
                },
                errorPlacement: function (error, element) {

                    //element.parent().append(error); // добавим в родительский блок input-а
                    error.insertBefore(element);

                }
            });
        })

        function showOneStudent(id) {
            $.get('/getOneStudent/' + id, function (data) {
                $("#id").val(id);
                $("#fio").val(data.fio);
                $("#bornDate").val(data.bornDate);
                $("#sticket").val(data.sticket);
                $('.searchInput').text(JSON.stringify(data.party))
                $('.searchInput').val(data.party.name)
                $("#studentForm").css("display", "");
                //document.getElementById('studentForm').removeAttribute("class");
            });
        }


        function showAllStudent() {
            $.get('/getAllStudent', function (data) {
                var arr = [];
                for (let i = 0; i < data.length; i++) {

                    arr.push(
                        {
                            "DT_RowId": data[i].id,
                            "fio": data[i].fio,
                            "party": data[i].party.name,
                            "sticket": data[i].sticket,
                            "bornDate": data[i].bornDate,
                            "ChangeButton": '<button type="button" class="imgButton" onclick="showOneStudent(' + data[i].id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                            "DeleteButton": '<a class="ssilka"href="/DeleteStudent/' + data[i].id + '">Удалить студента</a>'
                        }
                    );
                }
                var table = $('#myTable').DataTable({
                    "columns": [
                        {
                            "title": "ФИО", "data": "fio", "visible": true,
                        },
                        {
                            "title": "Название группы", "data": "party", "visible": true,
                        },
                        {
                            "title": "Номер студ билета", "data": "sticket", "visible": true,
                        },
                        {
                            "title": "Дата рождения", "data": "bornDate", "visible": true,
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
            $("#studentForm").css("display", "none");
            showAllStudent();
            $("#studentForm").on('submit', function (e) {
                e.preventDefault();
                $("#span_name").text("");
                if ($("#studentForm").valid()) {
                    $.ajax({
                        type: 'POST',
                        url: "/addStudent",
                        contentType: 'application/json; charset=utf-8',
                        data: JSON.stringify({
                            id: $("#id").val(),
                            fio: $("#fio").val(),
                            party: JSON.parse($(".searchInput").text()),
                            bornDate: $("#bornDate").val(),
                            sticket: $("#sticket").val()
                        }),
                        dataType: 'json',
                        async: true
                    }).done(function (data) {
                        var table = $('#myTable').DataTable();
                        $("#studentForm").css("display", "none");
                        if ($("#" + data.id + "").length) {
                            table.row($("#" + data.id + "")).remove().draw();
                            table.row.add({
                                "DT_RowId": data.id,
                                "fio": data.fio,
                                "party": data.party.name,
                                "sticket": data.sticket,
                                "bornDate": data.bornDate,
                                "ChangeButton": '<button type="button" class="imgButton" onclick="showOneStudent(' + data.id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                                "DeleteButton": '<a class="ssilka"href="/DeleteStudent/' + data.id + '">Удалить студента</a>'
                            }).draw();

                        } else {

                            table.row.add({
                                "DT_RowId": data.id,
                                "fio": data.fio,
                                "party": data.party.name,
                                "sticket": data.sticket,
                                "bornDate": data.bornDate,
                                "ChangeButton": '<button type="button" class="imgButton" onclick="showOneStudent(' + data.id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                                "DeleteButton": '<a class="ssilka"href="/DeleteStudent/' + data.id + '">Удалить студента</a>'
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
            //document.getElementById('studentForm').removeAttribute("class");
            $("#id").val('');
            $("#fio").val('');
            $("#bornDate").val('');
            $("#sticket").val('');
            $('.searchInput').val('');
            $("#studentForm").css("display", "");
        }

        function hide() {
            //document.getElementById('studentForm').classList.add('visible');
            $("#studentForm").css("display", "none");
        }

    </script>

</head>
<body>
<div class="size1">

    <jsp:include page="header.jsp"/>


    <div class="roboto">
        <div class="size2">
            <form id="studentForm" action="/addStudent"
                  class="form-horizontal rounded rounded-3 border border-3 p-2 border-secondary">

                <input type='hidden' name='id' id='id'/>

                <div class="form-group">
                    <label class="control-label">ФИО студента</label>
                    <input type='text' name='fio' id='fio' class="form-control"/>
                </div>
                <div class="form-group">
                    <label class="control-label">Номер билета</label>
                    <input type='number' name='sticket' id='sticket' class="form-control"/>
                </div>
                <div class="form-group">
                    <label class="control-label">Дата рождения</label>
                    <input type='text' name='bornDate' id="bornDate" class="form-control"/>
                </div>
                <span id="span_name"></span>
                <div class="form-group">
                    <p>Поиск по группам:</p>
                    <input ENGINE="text" name="referal" placeholder="Живой поиск" value='' class="searchInput"
                           autocomplete="off">
                    <ul class="searchResult"></ul>
                </div>
                <div class="form-group">
                    <img class="icon" onclick="hide()" alt="logo_1"
                         src="/resources/image/back.png">

                    <button type="button " class="imgButton"><img class="icon" alt="logo_1"
                                                                  src="/resources/image/disc.png">
                    </button>
                </div>
            </form>


            <button type="button" onclick="send()" class="imgButton"><img class="icon" alt="logo_1"
                                                                          src="/resources/image/plus.png"></button>
            <table id='myTable' class="table table-bordered table-striped border-dark border border-2 table-hover">
                <thead>
                <th>ФИО</th>
                <th>Название группы</th>
                <th>Номер студ билета</th>
                <th>Дата рождения</th>
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