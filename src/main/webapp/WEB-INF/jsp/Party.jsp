<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Party</title>
    <jsp:include page="import.jsp"/>
    <script>

        function showParty(id) {
            $.get('/getOneParty/' + id, function (data) {
                $("#id").val(id);
                $("#name").val(data.name);
                $("#course").val(data.course);
                $("#partyForm").css("display", "");
                //document.getElementById('partyForm').removeAttribute("class");
            });
        }

        function send() {
            $("#id").val('');
            $("#name").val('');
            $("#course").val('');
            $("#partyForm").css("display", "");
            //document.getElementById('partyForm').removeAttribute("class");
        }

        function showAllParty() {
            $.get('/getAllParty', function (data) {
                var arr = [];
                for (let i = 0; i < data.length; i++) {
                    arr.push(
                        {
                            "DT_RowId": data[i].id,
                            "name": data[i].name,
                            "course": data[i].course,
                            "ChangeButton": '<button type="button" class="imgButton" onclick="showParty(' + data[i].id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                            "DeleteButton": '<a class="ssilka" href="/DeleteParty/' + data[i].id + '">Удалить группу</a>'
                        }
                    );
                }
                var table = $('#myTable').DataTable({
                    "columns": [
                        {
                            "title": "Название группы", "data": "name", "visible": true,
                        },
                        {
                            "title": "Название курса", "data": "course", "visible": true,
                        },
                        {
                            "title": "Кнопка изменения", "data": "ChangeButton", "visible": true,
                        },
                        {
                            "title": "Кнопка удаления", "data": "DeleteButton", "visible": true,
                        }
                    ], "language": language(),
                    data: arr,
                    responsive: true
                });
            });
        }


        $(document).ready(function () {
            $("#partyForm").css("display", "none");
            showAllParty();
            $("#partyForm").on('submit', function (e) {
                e.preventDefault();
                $("#span_name").text("");
                if ($("#partyForm").valid()) {
                    $.post('/addParty', {
                        id: $("#id").val(),
                        name: $("#name").val(),
                        course: $("#course").val()
                    }, null, "json")
                        .done(function (data) {
                            //document.getElementById('partyForm').classList.add('visible');
                            $("#partyForm").css("display", "none");
                            var table = $('#myTable').DataTable();
                            if ($("#" + data.id + "").length) {
                                table.row($("#" + data.id + "")).remove().draw();
                                table.row.add({
                                    "DT_RowId": data.id,
                                    "name": data.name,
                                    "course": data.course,
                                    "ChangeButton": '<button type="button" class="imgButton" onclick="showParty(' + data.id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                                    "DeleteButton": '<a class="ssilka"href="/DeleteParty/' + data.id + '">Удалить группу</a>'
                                }).draw();
                            } else {
                                console.log("НЕ ПРОШЛО");
                                table.row.add({
                                    "DT_RowId": data.id,
                                    "name": data.name,
                                    "course": data.course,
                                    "ChangeButton": '<button type="button" class="imgButton" onclick="showParty(' + data.id + ')"><img class="icon" alt="logo_1"src="/resources/image/recycle.png"/></button>',
                                    "DeleteButton": '<a class="ssilka"href="/DeleteParty/' + data.id + '">Удалить группу</a>'
                                }).draw();
                            }

                        }).fail(function (data) {
                        if (data.status == 404) {
                            $("#span_name").text("Название должно быть уникальным");
                        }
                    });
                }
            });


        });


        $.validator.addMethod('symbols', function (value, element) {
            return value.match(new RegExp("^" + "[А-Яа-яЁё ]" + "+$"));
        }, "Здесь должны быть только русские символы");
        $(function () {
            $("#partyForm").validate
            ({
                rules: {
                    name: {
                        required: true,
                        symbols: true,
                        minlength: 3

                    },
                    course: {
                        required: true,
                        symbols: true,
                        minlength: 3
                    }
                },
                messages: {
                    name: {
                        required: 'Это поле не должно быть пустым',
                        minlength: 'Название группы должно содержать больше 3 символов'
                    },
                    course: {
                        required: 'Это поле не должно быть пустым',
                        minlength: 'Название курса должно содержать больше 3 символов'
                    }
                },
                errorPlacement: function (error, element) {
                    if (element.attr("name") == "name")
                        $("#spanName").text(error.text());
                    if (element.attr("name") == "course")
                        $("#spanCourse").text(error.text());
                }
            });
        })


        function hide() {
            //document.getElementById('partyForm').classList.add('visible');
            $("#partyForm").css("display", "none");
        }
    </script>
</head>

<body>
<div class="size1 container">
    <jsp:include page="header.jsp"/>
    <div class="roboto container">
        <div class="size2 container">
            <form id="partyForm" class="form-horizontal rounded rounded-3 border border-3 p-2 border-secondary"
                  action="/addParty">

                <input type='hidden' name='id' id='id'/>
                <div class="form-group">
                    <label class="control-label ">Название группы</label>
                    <input type='text' name='name' id='name' class="form-control "/>
                    <span id="span_name"></span>
                    <span id="spanName"></span>
                </div>
                <div class="form-group ">
                    <label class="control-label ">Название курса</label>
                    <input type='text' name='course' id='course' class="form-control "/>
                    <span id="spanCourse"></span>
                </div>
                <div class="form-group flex-column col-5">
                    <img class="icon" alt="logo_1" src="/resources/image/back.png" onclick="hide()">
                    <button type="submit" class="imgButton"><img class="icon" alt="logo_1"
                                                                 src="/resources/image/disc.png">
                    </button>

                </div>
            </form>
            <button type="button" onclick="send()" class="imgButton"><img class="icon" alt="logo_1"
                                                                          src="/resources/image/plus.png"></button>
            <table id='myTable'
                   class="table table-bordered table-striped border-dark border border-2 table-hover">
                <thead>
                <th>Название группы</th>
                <th>Название курса</th>
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