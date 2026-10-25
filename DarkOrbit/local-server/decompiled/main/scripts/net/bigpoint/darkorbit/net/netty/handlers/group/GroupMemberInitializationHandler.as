package net.bigpoint.darkorbit.net.netty.handlers.group
{
   import net.bigpoint.darkorbit.com.module.GroupMemberInitializationCommand;
   import net.bigpoint.darkorbit.com.module.HealthModule;
   import net.bigpoint.darkorbit.com.module.LocationModule;
   import net.bigpoint.darkorbit.com.module.TargetModule;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.GroupMember;
   import net.bigpoint.darkorbit.net.netty.handlers.group.base.GroupSystemHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class GroupMemberInitializationHandler extends GroupSystemHandler
   {
      
      public function GroupMemberInitializationHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:GroupMemberInitializationCommand = param1.getBody() as GroupMemberInitializationCommand;
         var _loc3_:HealthModule = _loc2_.health;
         var _loc4_:LocationModule = _loc2_.location;
         var _loc5_:TargetModule = _loc2_.target;
         var _loc6_:GroupMember = new GroupMember();
         _loc6_.init(_loc2_.id,_loc2_.name,_loc3_.hp,_loc3_.hpMax,_loc3_.nanoHull,_loc3_.nanoHullMax,_loc3_.shield,_loc3_.shieldMax,_loc4_.mapId,_loc4_.x,_loc4_.y,_loc2_.level,_loc2_.active,_loc2_.cloaked,_loc2_.inFight,_loc2_.faction.faction,_loc2_.shipIcon.shipIcon,_loc2_.clan.clanTag,_loc5_.shipType.shipIcon,_loc2_.loggedOut,_loc2_.raidGateGameStage.gameStage);
         _loc6_.isInRaidGate = _loc2_.raidGateGameStage.isInGate;
         _loc6_.isSelected = Boolean(map.lockManager.target) && map.lockManager.target.id == _loc2_.id;
         _loc6_.targetObject.nickname = _loc5_.name;
         _loc6_.targetObject.hitPointsCurrent = _loc5_.health.hp;
         _loc6_.targetObject.hitPointsMax = _loc5_.health.hpMax;
         _loc6_.targetObject.nanohullCurrent = _loc5_.health.nanoHull;
         _loc6_.targetObject.nanohullMax = _loc5_.health.nanoHullMax;
         _loc6_.targetObject.shieldCurrent = _loc5_.health.shield;
         _loc6_.targetObject.shieldMax = _loc5_.health.shieldMax;
         groupProxy.addMember(_loc6_);
      }
   }
}

