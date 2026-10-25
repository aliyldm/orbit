package net.bigpoint.darkorbit.mvc.events.control
{
   import net.bigpoint.darkorbit.map.model.env.homebase.Headquarters;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HandleDemolishedHQCommand extends DOAbstractSimpleCommand
   {
      
      public function HandleDemolishedHQCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:Headquarters = null;
         super.execute(param1);
         var _loc2_:Vector.<Headquarters> = Vector.<Headquarters>(map.getEntityByType(Headquarters));
         for each(_loc3_ in _loc2_)
         {
            _loc3_.update();
         }
      }
   }
}

