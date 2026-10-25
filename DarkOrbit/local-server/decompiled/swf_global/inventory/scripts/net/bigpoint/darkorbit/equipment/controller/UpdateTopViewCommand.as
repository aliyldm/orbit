package net.bigpoint.darkorbit.equipment.controller
{
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.VO.Config;
   import net.bigpoint.darkorbit.equipment.model.VO.Drone;
   import net.bigpoint.darkorbit.equipment.model.VO.Equipment;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotItemVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetVO;
   import net.bigpoint.darkorbit.equipment.view.components.items.ItemFilter;
   import net.bigpoint.dataInterchange.DataInterchange;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class UpdateTopViewCommand extends SimpleCommand
   {
      
      public function UpdateTopViewCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Array = this.playerInvProxy.equipmentManager.ship.selectedDesign.split("_");
         var _loc3_:String = "DEFAULT_" + ItemFilter.EMPTY_SPACE_FILTER;
         var _loc4_:String = _loc3_;
         if(_loc2_.length > 1)
         {
            _loc4_ = _loc2_.pop();
         }
         else
         {
            _loc4_ = _loc3_ + ItemFilter.EMPTY_SHIP_POSFTFIX;
         }
         sendNotification(ApplicationNotificationNames.CHANGE_ENTITY_GRAPHIC,[ActionIdentifiers.SHIP,_loc4_]);
         var _loc5_:Drone = this.playerInvProxy.equipmentManager.drones[this.playerInvProxy.equipmentManager.generalDrone.ID];
         if(_loc5_ != null)
         {
            _loc2_ = _loc5_.lootID.split("_");
            if(_loc2_.length > 1)
            {
               _loc4_ = _loc2_.pop() + "-" + 5;
            }
            else
            {
               _loc4_ = _loc3_;
            }
            sendNotification(ApplicationNotificationNames.CHANGE_ENTITY_GRAPHIC,[ActionIdentifiers.DRONES,_loc4_]);
         }
         if(this.playerInvProxy.equipmentManager.pet != null)
         {
            sendNotification(ApplicationNotificationNames.CHANGE_ENTITY_GRAPHIC,[ActionIdentifiers.PET,this.getPetTopViewFilename()]);
         }
      }
      
      private function get playerInvProxy() : ConnectionProxy
      {
         return facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
      }
      
      private function getPetTopViewFilename() : String
      {
         var _loc4_:SlotItemVO = null;
         var _loc1_:Equipment = Config(this.playerInvProxy.configManager.configs[this.playerInvProxy.activeConfig]).getEquipment(ActionIdentifiers.PET) as Equipment;
         var _loc2_:SlotSetVO = _loc1_.slotSets.visual as SlotSetVO;
         if(_loc2_)
         {
            for each(_loc4_ in _loc2_.items)
            {
               if(_loc4_.itemInstance.itemInfo.group.name == DataInterchange.PET_DESIGN_VISUAL_TYPE_CLASS)
               {
                  return _loc4_.itemInstance.itemInfo.graphicKey;
               }
               if(_loc4_.itemInstance.itemInfo.group.name == DataInterchange.PET_DESIGN_STATS_TYPE_CLASS && Boolean(_loc4_.itemInstance.itemInfo.graphicKey))
               {
                  return _loc4_.itemInstance.itemInfo.graphicKey;
               }
            }
         }
         var _loc3_:Array = this.playerInvProxy.equipmentManager.pet.lootID.split("_");
         if(_loc3_.length > 1)
         {
            return _loc3_.pop() + "-" + this.playerInvProxy.equipmentManager.pet.level;
         }
         return ItemFilter.EMPTY_SPACE_FILTER;
      }
   }
}

