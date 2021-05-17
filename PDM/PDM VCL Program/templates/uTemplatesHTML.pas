unit uTemplatesHTML;

interface

const

    TASKLIST_STYLE =
    'body,html{margin:0;padding:3;}'+
    '.task, .message{background-color:RGB(244,247,252);padding:3;margin-bottom:10;border:1 solid gray;text-align:right;}'+
    '.complete{background-color:RGB(192,220,192);}'+
    '.content{background-color:#fff;width:100%;padding:10;}'+
    'image{border:0;}'+
    'table{width:99%;}'+
    'table span{font-weight:bold;}'+
    '.task td{width:24.9%;}'+
    'td.last{text-align: right;}'+
    '.comment{width: 95%;}'+
    '.content{text-align:left;}'
    ;

    TASK_TEMPLATE_HTML =
    '<div class="task #class#"> '+
    ' <table>'+
    '   <tr>'+
    '     <td> '+
    '       Инициатор: <span>#initiator#</span>'+
    '     </td> '+
    '     <td> '+
    '       Создано: <span>#created#</span>'+
    '     </td> '+
    '     <td> '+
    '       Подтверждено: <span>#accepted#</span>'+
    '     </td> '+
    '     <td class=last> '+
    '       <a style=button href="edit:#ID#"><img src="#edit_img#" /></a> '+
    '       <a style=button href="delete:#ID#"><img src="#delete_img#" /></a> '+
    '     </td> '+
    '   </tr>'+
    '   <tr>'+
    '     <td> '+
    '       Исполнитель: <span>#executer#</span>'+
    '     </td> '+
    '     <td> '+
    '       Завершено: <span>#complete#</span>'+
    '     </td> '+
    '     <td>'+
    '       Статус: <span>#status#</span>'+
    '     </td> '+
    '     <td>'+
    '     </td>'+
    '   </tr>'+
    ' </table>'+
      '<div class=content>'+
        '#text#'+
      '</div>'+
      '<div class=comment>'+
        '#comment#'+
    '</div>'+
    '</div>';

    MESSAGE_TEMPLATE_HTML =
    '<div class="message #class#"> '+
    ' <table>'+
    '   <tr>'+
    '     <td> '+
    '       <span>#initiator#</span>'+
    '     </td> '+
    '     <td> '+
    '       <span>#created#</span>'+
    '     </td> '+
    '     <td> '+
    '       Проект: <span>#project#</span>'+
    '     </td> '+
    '     <td class=last> '+
    '       <a style=button href="edit:#ID#"><img src="#edit_img#" /></a> '+
    '       <a style=button href="delete:#ID#"><img src="#delete_img#" /></a> '+
    '     </td> '+
    '   </tr>'+
    ' </table>'+
    ' <div class=content> '+
    '    #text# '+
    ' </div> '+
    '</div>';

    COMMENT_TEMPLATE_HTML =
    '<div class="comment #class#"> '+
    ' <table>'+
    '   <tr>'+
    '     <td> '+
    '       <span>#initiator#</span>'+
    '     </td> '+
    '     <td> '+
    '       <span>#created#</span>'+
    '     </td> '+
    '     <td class=last> '+
    '       <a style=button href="edit:#ID#"><img src="#edit_img#" /></a> '+
    '       <a style=button href="delete:#ID#"><img src="#delete_img#" /></a> '+
    '     </td> '+
    '   </tr>'+
    ' </table>'+
    ' <div class=content> '+
    '    #text# '+
    ' </div> '+
    '</div>';

implementation

end.
