package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.LootModule;
   
   public class DispatchGateDefinition
   {
      
      private static var _defaultList:Dictionary = null;
      
      private var _id:int;
      
      private var _dispatchId:String;
      
      private var _iconId:String;
      
      private var _name:String;
      
      private var _gateId:int;
      
      private var _duration:int;
      
      private var _sendCost:LootModule;
      
      public function DispatchGateDefinition(param1:int, param2:String, param3:String, param4:String, param5:int, param6:int, param7:LootModule)
      {
         super();
         this._id = param1;
         this._dispatchId = param2;
         this._iconId = param3;
         this._name = param4;
         this._gateId = param5;
         this._duration = param6;
         this._sendCost = param7;
      }
      
      public static function getGateDefinition(param1:int) : DispatchGateDefinition
      {
         if(_defaultList == null)
         {
            initList();
         }
         return _defaultList[param1];
      }
      
      private static function initList() : void
      {
         _defaultList = new Dictionary();
         _defaultList[1] = new DispatchGateDefinition(1,"dispatch_gate_g01","g01","gate_title_alpha",1,1800,new LootModule("resource_collectable_ggeu",1));
         _defaultList[2] = new DispatchGateDefinition(2,"dispatch_gate_g02","g02","gate_title_beta",2,1800,new LootModule("resource_collectable_ggeu",1));
         _defaultList[3] = new DispatchGateDefinition(3,"dispatch_gate_g03","g03","gate_title_gamma",3,1800,new LootModule("resource_collectable_ggeu",1));
         _defaultList[5] = new DispatchGateDefinition(4,"dispatch_gate_g04","g04","gate_title_delta",5,1800,new LootModule("resource_collectable_ggeu",1));
         _defaultList[8] = new DispatchGateDefinition(5,"dispatch_gate_g05","g05","gate_title_epsilon",8,1800,new LootModule("resource_collectable_ggeu",1));
         _defaultList[10] = new DispatchGateDefinition(6,"dispatch_gate_g06","g06","gate_title_kappa",10,1800,new LootModule("resource_collectable_ggeu",1));
         _defaultList[12] = new DispatchGateDefinition(7,"dispatch_gate_g07","g07","gate_title_kronos",12,3600,new LootModule("resource_collectable_ggeu",1));
         _defaultList[11] = new DispatchGateDefinition(8,"dispatch_gate_g08","g08","gate_title_lambda",11,1800,new LootModule("resource_collectable_ggeu",1));
         _defaultList[9] = new DispatchGateDefinition(9,"dispatch_gate_g09","g09","gate_title_zeta",9,1800,new LootModule("resource_collectable_ggeu",1));
         _defaultList[19] = new DispatchGateDefinition(9,"dispatch_gate_g10","g10","gate_title_streuner",19,1800,new LootModule("resource_collectable_ggeu",1));
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get dispatchId() : String
      {
         return this._dispatchId;
      }
      
      public function get iconId() : String
      {
         return this._iconId;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get gateId() : int
      {
         return this._gateId;
      }
      
      public function get duration() : int
      {
         return this._duration;
      }
      
      public function get sendCost() : LootModule
      {
         return this._sendCost;
      }
   }
}

