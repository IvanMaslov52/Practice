<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Teacher</title>
    <jsp:include page="import.jsp"/>
    <link rel="canonical" href="https://mdbootstrap.com/docs/b4/jquery/forms/date-picker/">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script>
        $(function () {
            $('.searchInput').bind("change keyup input click", function () {
                if (this.value.length >= 2) {
                    $.ajax({
                        url: "/subjectFind/" + this.value, //Путь к обработчику
                        type: 'get',
                        cache: false,
                        success: function (data) {
                            $(".searchResult").html(data).fadeIn(); //Выводим полученые данные в списке
                            for (let i = 0; i < data.length; i++) {
                                $('.searchResult').append("<li data-attr='" + JSON.stringify(data[i]) + "'> " + data[i].name + "</li>");
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
                $('#subjects option:contains("' + $(this).text().trim() + '")').prop('selected', true);
                if ($("#" + $(this).text().trim() + "").length) {
                } else {
                    $('#selectedElem').append("<li id='" + $(this).text().trim() + "'> " + $(this).text().trim() + "</li>");
                }
                $(".searchInput").val($(this).text().trim())
                $(".searchResult").fadeOut();
            })


            $("#selectedElem").on("click", "li", function () {
                $('#subjects option:contains("' + $(this).text().trim() + '")').prop('selected', false);
                $(this).remove();
            })


        })


        $.validator.addMethod('symbols', function (value, element) {
            return value.match(new RegExp("^" + "[А-Яа-яЁё ]" + "+$"));
        }, "Здесь должны быть только русские символы");
        $(function () {
            $("#bornDate").datepicker({dateFormat: 'dd/mm/yy'});
        });
        $(function () {
            $("#teacherForm").validate
            ({
                rules: {
                    fio: {
                        required: true,
                        symbols: true,
                        minlength: 4
                    },
                    speciality: {
                        required: true,
                        symbols: true,
                        minlength: 3
                    }
                },
                messages: {
                    speciality: {
                        required: 'Это поле не должно быть пустым',
                        minlength: 'Здесь не может быть меньше 4 символов'
                    },
                    fio: {
                        required: 'Это поле не должно быть пустым',
                        minlength: 'Здесь не может быть меньше 3 символов'
                    }
                },
                errorPlacement: function (error, element) {

                    //element.parent().append(error); // добавим в родительский блок input-а
                    error.insertBefore(element);

                }
            });
        })

        function showTeacher(id) {
            $.get('/getOneTeacher/' + id, function (data) {
                $("#subjects").val('');
                $('li').remove();
                $("#id").val(data.id);
                $("#speciality").val(data.speciality);
                $("#bornDate").val(data.bornDate);
                $("#fio").val(data.fio);
                for (let i = 0; i < data.subjects.length; i++) {
                    $('#subjects option:contains("' + data.subjects[i].name.trim() + '")').prop('selected', true);
                    $('#selectedElem').append("<li id='" + data.subjects[i].name.trim() + "'> " + data.subjects[i].name.trim() + "</li>");
                }
                $("#teacherForm").css("display", "");
                //document.getElementById('teacherForm').removeAttribute("class");
            });
        }

        function send() {
            $('li').remove();
            $("#id").val('');
            $("#fio").val('');
            $("#speciality").val('');
            $("#bornDate").val('');
            $("#subjects").val('');
            $("#teacherForm").css("display", "");
            //document.getElementById('teacherForm').removeAttribute("class");
        }

        function hide() {
            $("#teacherForm").css("display", "none");
            //document.getElementById('teacherForm').classList.add('visible');
        }

        $(document).ready(function () {
            $("#teacherForm").css("display", "none");
            showAllTeacher();
            $("#teacherForm").on('submit', function (e) {
                e.preventDefault();
                let str = '[';
                for (let i = 0; i < $('#subjects').val().length; i++) {
                    if (i == $('#subjects').val().length - 1) {
                        str += $('#subjects option:contains("' + $('#subjects').val()[i] + '")').attr('data-attr');
                    } else {
                        str += $('#subjects option:contains("' + $('#subjects').val()[i] + '")').attr('data-attr') + ',';
                    }
                }
                str += ']';
                if ($("#teacherForm").valid()) {
                    $.ajax({
                        type: 'POST',
                        url: "/addTeacher",
                        contentType: 'application/json; charset=utf-8',
                        data: JSON.stringify({
                            id: $("#id").val(),
                            speciality: $("#speciality").val(),
                            fio: $("#fio").val(),
                            bornDate: $("#bornDate").val(),
                            subjects: JSON.parse(str)
                        }),
                        dataType: 'json',
                        async: true
                    }).done(function (data) {
                        var string = "";
                        console.log(data.subjects.length)
                        for (let i = 0; i < data.subjects.length; i++) {
                            if (i == data.subjects.length - 1) {
                                string += data.subjects[i].name;
                            } else {
                                string += data.subjects[i].name + ',';
                            }
                        }
                        var table = $('#myTable').DataTable();
                        $("#teacherForm").css("display", "none");
                        //document.getElementById('teacherForm').classList.add('visible');
                        if ($("#" + data.id + "").length) {
                            table.row($("#" + data.id + "")).remove().draw();
                            table.row.add({
                                "DT_RowId": data.id,
                                "fio": data.fio,
                                "subjects": string,
                                "speciality": data.speciality,
                                "bornDate": data.bornDate,
                                "ChangeButton": '<button type="button" class="imgButton" onclick="showTeacher(' + data.id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                                "DeleteButton": '<a class="ssilka"href="/DeleteTeacher/' + data.id + '">Удалить учителя</a>'
                            }).draw();

                        } else {
                            table.row.add({
                                "DT_RowId": data.id,
                                "fio": data.fio,
                                "subjects": string,
                                "speciality": data.speciality,
                                "bornDate": data.bornDate,
                                "ChangeButton": '<button type="button" class="imgButton" onclick="showTeacher(' + data.id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                                "DeleteButton": '<a class="ssilka"href="/DeleteTeacher/' + data.id + '">Удалить учителя</a>'
                            }).draw();
                        }
                    });
                }
            });

        });

        function showAllTeacher() {
            $.get('/getAllTeacher', function (data) {
                var arr = [];
                for (let i = 0; i < data.length; i++) {
                    var string = "";
                    for (let j = 0; j < data[i].subjects.length; j++) {
                        if (j == data[i].subjects.length - 1) {
                            string += data[i].subjects[j].name;
                        } else {
                            string += data[i].subjects[j].name + ',';
                        }
                    }
                    arr.push({
                        "DT_RowId": data[i].id,
                        "fio": data[i].fio,
                        "subjects": string,
                        "speciality": data[i].speciality,
                        "bornDate": data[i].bornDate,
                        "ChangeButton": '<button type="button" class="imgButton" onclick="showTeacher(' + data[i].id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                        "DeleteButton": '<a class="ssilka"href="/DeleteTeacher/' + data[i].id + '">Удалить учителя</a>'
                    });
                }
                var table = $('#myTable').DataTable({
                    "columns": [
                        {
                            "title": "ФИО", "data": "fio", "visible": true,
                        },
                        {
                            "title": "Дата рождения", "data": "bornDate", "visible": true,
                        },
                        {
                            "title": "Предметы", "data": "subjects", "visible": true,
                        },
                        {
                            "title": "Специальность", "data": "speciality", "visible": true,
                        },
                        {
                            "title": "Кнопка изменения", "data": "ChangeButton", "visible": true,
                        },
                        {
                            "title": "Кнопка удаления", "data": "DeleteButton", "visible": true,
                        }
                    ],
                    "language": language(),
                    data: arr
                });
            });
        }

    </script>
</head>

<body>
<div class="size1">

    <jsp:include page="header.jsp"/>

    <div class="roboto">
        <div class="size2">
            <form id="teacherForm" class="form-horizontal rounded rounded-3 border border-3 p-2 border-secondary">

                <input type='hidden' name='id' id='id'/>

                <div class="form-group">
                    <label class="control-label">Специализация</label>
                    <input type='text' name='speciality' id='speciality' class="form-control"/></div>
                <div class="form-group">
                    <label class="control-label">Дата рождения</label>
                    <input type='text' name='bornDate' id='bornDate' class="form-control"/>
                </div>
                <div class="form-group">
                    <label class="control-label">ФИО</label>
                    <input type='text' name='fio' id='fio' class="form-control"/>
                </div>

                <select name="subjects" multiple="multiple" id="subjects" class="visible">
                    <c:forEach items='${subjectList}' var='subjects'>
                        <option value='${subjects.name}'
                                data-attr='${subjects}'>${subjects.name}</option>
                    </c:forEach>
                </select>

                <div class="form-group">
                    <div>
                        <p>Поиск по предметам:</p>
                        <input ENGINE="text" name="referal" placeholder="Живой поиск" value="" class="searchInput"
                               autocomplete="off">
                        <ul class="searchResult"></ul>
                    </div>

                    <div class="resultDiv">
                        <p>Выбранные элементы</p>
                        <ul id="selectedElem">
                        </ul>
                    </div>

                </div>

                <div class="form-group">
                    <img class="icon" onclick="hide()" alt="logo_1" src="/resources/image/back.png">

                    <button type="button " class="imgButton"><img class="icon" alt="logo_1"
                                                                  src="/resources/image/disc.png">
                    </button>
                </div>
            </form>


            <button type="button" onclick="send()" class="imgButton"><img class="icon" alt="logo_1"
                                                                          src="/resources/image/plus.png"></button>
        </div>

        <div class="size2">
            <table id="myTable" class="table table-bordered table-striped border-dark border border-2 table-hover">
                <thead>
                <th>ФИО</th>
                <th>Дата рождения</th>
                <th>Предметы</th>
                <th>Специальность</th>
                <th>Кнопка изменения</th>
                <th>Кнопка удаления</th>
                </thead>
                <tbody>
                </tbody>
            </table>
        </div>
    </div>

    <div class=" size2">
    </div>
    <jsp:include page="footer.jsp"/>
</div>

</body>
</html>