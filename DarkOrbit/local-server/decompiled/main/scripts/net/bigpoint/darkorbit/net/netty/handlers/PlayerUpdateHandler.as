package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.PlayerAttributeModule;
   import net.bigpoint.darkorbit.com.module.PlayerUpdateCommand;
   import net.bigpoint.darkorbit.com.module.RaidGateGameStageModule;
   import net.bigpoint.darkorbit.mvc.groupsystem.notification.GroupSystemNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class PlayerUpdateHandler extends SimpleCommand
   {
      
      public function PlayerUpdateHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:Vector.<PlayerAttributeModule> = (param1.getBody() as PlayerUpdateCommand).updates;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            this.updateHero(_loc2_[_loc4_]);
            _loc4_++;
         }
      }
      
      private function updateHero(param1:PlayerAttributeModule) : void
      {
         var _loc2_:Boolean = false;
         switch(param1.getLibcomModuleId())
         {
            case RaidGateGameStageModule.instance.getLibcomModuleId():
               _loc2_ = !_loc2_ && Hero.raidGateStatus != (param1 as RaidGateGameStageModule).gameStage ? true : _loc2_;
               Hero.raidGateStatus = (param1 as RaidGateGameStageModule).gameStage;
         }
         if(_loc2_)
         {
            sendNotification(GroupSystemNotification.RELATED_DATA_CHANGED);
         }
      }
   }
}

