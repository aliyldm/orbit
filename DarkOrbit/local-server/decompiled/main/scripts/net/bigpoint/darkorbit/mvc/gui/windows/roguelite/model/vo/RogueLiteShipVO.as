package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   
   public class RogueLiteShipVO
   {
      
      public var selected:BindableBoolean = new BindableBoolean();
      
      private var _loadoutId:String;
      
      private var _shipVO:ItemVO;
      
      private var _shipEquipmentVO:RogueLiteShipEquipmentVO;
      
      private var _petVO:ItemVO;
      
      private var _petEquipmentVO:RogueLitePetEquipmentVO;
      
      private var _dronesVO:Vector.<RogueLiteDroneVO>;
      
      private var _hp:int;
      
      private var _shield:int;
      
      private var _spread:int;
      
      private var _speed:int;
      
      public function RogueLiteShipVO(param1:String, param2:String, param3:int, param4:int, param5:int, param6:int, param7:RogueLiteShipEquipmentVO, param8:String, param9:RogueLitePetEquipmentVO, param10:Vector.<RogueLiteDroneVO>)
      {
         super();
         this._loadoutId = param1;
         this._shipVO = ItemDataProviderHelper.getItem(param2);
         this._shipEquipmentVO = param7;
         this._petVO = ItemDataProviderHelper.getItem(param8);
         this._petEquipmentVO = param9;
         this._dronesVO = param10;
         this._hp = param3;
         this._shield = param4;
         this._spread = param5;
         this._speed = param6;
      }
      
      public function get loadoutId() : String
      {
         return this._loadoutId;
      }
      
      public function get shipName() : String
      {
         return this._shipVO.fullname;
      }
      
      public function get hp() : int
      {
         return this._hp;
      }
      
      public function get shield() : int
      {
         return this._shield;
      }
      
      public function get spread() : int
      {
         return this._spread;
      }
      
      public function get speed() : int
      {
         return this._speed;
      }
      
      public function get shipVO() : ItemVO
      {
         return this._shipVO;
      }
      
      public function get shipEquipmentVO() : RogueLiteShipEquipmentVO
      {
         return this._shipEquipmentVO;
      }
      
      public function get petVO() : ItemVO
      {
         return this._petVO;
      }
      
      public function get petEquipmentVO() : RogueLitePetEquipmentVO
      {
         return this._petEquipmentVO;
      }
      
      public function get dronesVO() : Vector.<RogueLiteDroneVO>
      {
         return this._dronesVO;
      }
   }
}

