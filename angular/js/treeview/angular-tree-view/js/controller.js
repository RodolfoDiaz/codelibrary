(function () {
  'use strict';
  var app = angular.module('Demo', ['AxelSoft']);

  app.controller('DemoController', ['$scope', function ($scope) {

    $scope.breadcrums = [''];

    $scope.structure = {
      folders: [{
        name: 'Folder 1',
        files: [{
          name: 'File 1.jpg'
        }, {
          name: 'File 2.png'
        }],
        folders: [{
          name: 'Subfolder 1',
          files: [{
            name: 'Subfile 1.txt'
          }]
        }, {
          name: 'Subfolder 2'
        }, {
          name: 'Subfolder 3'
        }]
      }, {
        name: 'Folder 2'
      }],
      files: [{
        name: 'File 1.gif'
      }, {
        name: 'File 2.gif'
      }]
    };

    $scope.options = {
      onNodeSelect: function (node, breadcrums) {
        $scope.breadcrums = breadcrums;
      }
    };

    $scope.options2 = {
      collapsible: false
    };

    var iconClassMap =
      {
        txt: 'fa fa-file-text',
        jpg: 'fa fa-file-image-o red',
        png: 'fa fa-file-image-o orange',
        gif: 'fa fa-file-image-o'
      },
      defaultIconClass = 'fa fa-file-code-o';

    $scope.options3 = {
      mapIcon: function (file) {
        var pattern = /\.(\w+)$/,
          match = pattern.exec(file.name),
          ext = match && match[1];

        return iconClassMap[ext] || defaultIconClass;
      }
    };
  }]);

})();
