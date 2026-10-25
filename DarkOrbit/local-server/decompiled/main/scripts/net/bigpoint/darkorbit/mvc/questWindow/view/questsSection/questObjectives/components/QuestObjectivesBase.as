package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questObjectives.components
{
   import flash.events.Event;
   import mx.events.FlexEvent;
   import spark.components.SkinnableContainer;
   
   public class QuestObjectivesBase extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      public function QuestObjectivesBase()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addetToStageHandler);
      }
      
      private function addetToStageHandler(param1:Event) : void
      {
      }
      
      protected function creationCompleteHandler(param1:FlexEvent) : void
      {
      }
   }
}

