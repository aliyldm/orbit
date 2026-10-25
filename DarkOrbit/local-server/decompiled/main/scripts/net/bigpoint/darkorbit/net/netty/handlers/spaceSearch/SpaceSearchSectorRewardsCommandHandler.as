package net.bigpoint.darkorbit.net.netty.handlers.spaceSearch
{
   import net.bigpoint.darkorbit.com.module.porting.SpaceSearch.SpaceSearchSectorRewardsCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.model.TabSpaceSearchRewardsProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SpaceSearchSectorRewardsCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function SpaceSearchSectorRewardsCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         TabSpaceSearchRewardsProxy.getOrCreateProxy(this.facade).updateData(param1.getBody() as SpaceSearchSectorRewardsCommand);
      }
   }
}

