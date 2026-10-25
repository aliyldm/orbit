package net.bigpoint.darkorbit.net.netty.handlers.spaceSearch
{
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchMissionListCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model.TabSpaceSearchMissionsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SpaceSearchMissionListCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SpaceSearchMissionListCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SpaceSearchMissionListCommand = param1.getBody() as SpaceSearchMissionListCommand;
         TabSpaceSearchMissionsProxy.getOrCreateProxy(this.facade).updateData(_loc2_);
      }
   }
}

