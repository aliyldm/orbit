package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo
{
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.items.item.attributes.drones.DroneAttributes;
   
   public class RogueLiteDroneVO
   {
      
      private var _droneVO:ItemVO;
      
      private var _attributes:DroneAttributes;
      
      private var _equip1:ItemVO;
      
      private var _equip2:ItemVO;
      
      public function RogueLiteDroneVO(param1:String, param2:int)
      {
         super();
         this._droneVO = ItemDataProviderHelper.getItem(param1);
         this._attributes = this._droneVO.item.attributes as DroneAttributes;
         this._droneVO.upgradeLevel = param2;
      }
      
      public function get droneVO() : ItemVO
      {
         return this._droneVO;
      }
      
      public function set equip1(param1:ItemVO) : void
      {
         this._equip1 = param1;
      }
      
      public function get equip1() : ItemVO
      {
         return this._equip1;
      }
      
      public function set equip2(param1:ItemVO) : void
      {
         this._equip2 = param1;
      }
      
      public function get equip2() : ItemVO
      {
         return this._equip2;
      }
      
      public function get droneName() : String
      {
         return this._droneVO.fullname;
      }
      
      public function get droneLevel() : int
      {
         return this._droneVO.upgradeLevel;
      }
      
      public function get droneEffect() : String
      {
         return (this._droneVO.upgradeLevel - 1) * 2 + "%/" + (this._droneVO.upgradeLevel - 1) * 4 + "%";
      }
      
      public function get droneSlot() : int
      {
         return this._attributes.slots;
      }
      
      public function get droneDamageLevel() : int
      {
         return 1;
      }
      
      public function get droneShieldLevel() : int
      {
         return 1;
      }
   }
}

