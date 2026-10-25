package net.bigpoint.darkorbit.mvc.events.control
{
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.events.model.eventVOs.AprilsFoolsEvent;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HandleAprilsFoolsCommand extends DOAbstractSimpleCommand
   {
      
      public function HandleAprilsFoolsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:AprilsFoolsEvent = param1.getBody() as AprilsFoolsEvent;
         if(_loc2_.isActive)
         {
            PatternManager.parseCustomLaserPatterns(Main.gameXML,Main.gameXML.patterns.laserDefinitionsAprilsFools as XMLList);
         }
         else
         {
            PatternManager.parseCustomLaserPatterns(Main.gameXML,Main.gameXML.patterns.laserDefinitions as XMLList);
         }
      }
   }
}

