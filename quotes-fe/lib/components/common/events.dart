import 'dart:async';

import 'package:angular/angular.dart';

import '../../domain/common/event.dart';

@Component(
    selector: 'events',
    templateUrl: 'events.template.html',
    directives: const [
      coreDirectives,
      InvalidDataComponent,
      InfoComponent,
      ErrorComponent
    ])
class Events {
  @Input()
  List<Event> events;

  void remove(Event e) {
    Future.delayed(Duration(milliseconds: 300), () {
      events.removeWhere((ev) => e.id == ev.id);
    });
  }

  Events get self => this;
}

@Component(selector: 'invalid-data-event', template: '''
    <div
      class="alert alert-danger alert-dismissible show"
      role="alert"
      *ngFor="let err of event.errors">

      {{ err.message }}

      <button type="button"
              class="close"
              data-dismiss="alert"
              aria-label="Close"
              (click)="hide()">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>''', directives: const [coreDirectives])
class InvalidDataComponent {
  @Input()
  InvalidDataEvent event;
  @Input()
  Events events;

  void hide() => events.remove(event);
}

@Component(selector: 'info-event', template: '''
      <div
        class="alert alert-success alert-dismissible"
        role="alert">

        {{ event.info }}

      <button type="button"
              class="close"
              data-dismiss="alert"
              aria-label="Close"
              (click)="hide()">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>''', directives: const [coreDirectives])
class InfoComponent {
  @Input()
  InfoEvent event;
  @Input()
  Events events;

  void hide() => events.remove(event);
}

@Component(selector: 'error-event', template: '''
      <div class="alert alert-danger alert-dismissible"
        role="alert">

      {{ event.msg }}

      <button type="button"
              class="close"
              data-dismiss="alert"
              aria-label="Close"
              (click)="hide()">
        <span aria-hidden="true">&times;</span>
      </button>
    </div>''', directives: const [coreDirectives])
class ErrorComponent {
  @Input()
  ErrorEvent event;
  @Input()
  Events events;

  void hide() => events.remove(event);
}
