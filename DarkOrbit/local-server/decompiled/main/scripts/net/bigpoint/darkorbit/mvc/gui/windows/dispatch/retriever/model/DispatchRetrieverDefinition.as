package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.com.module.LootModule;
   
   public class DispatchRetrieverDefinition
   {
      
      private static var _defaultList:Dictionary = null;
      
      private var _id:int;
      
      private var _iconId:String;
      
      private var _name:String;
      
      private var _type:String;
      
      private var _description:String;
      
      private var _tier:int;
      
      private var _duration:int;
      
      private var _sendCost:Vector.<LootModule>;
      
      private var _instantCost:LootModule;
      
      public function DispatchRetrieverDefinition(param1:int, param2:String, param3:String, param4:String, param5:int, param6:String, param7:int, param8:Vector.<LootModule>, param9:LootModule)
      {
         super();
         this._id = param1;
         this._iconId = param2;
         this._name = param3;
         this._type = param4;
         this._description = param6;
         this._tier = param5;
         this._duration = param7;
         this._sendCost = param8;
         this._instantCost = param9;
      }
      
      public static function getRetrieverDefinition(param1:int) : DispatchRetrieverDefinition
      {
         if(_defaultList == null)
         {
            initList();
         }
         return _defaultList[param1];
      }
      
      private static function initList() : void
      {
         var _loc1_:Vector.<LootModule> = null;
         _defaultList = new Dictionary();
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_credits",200000));
         _defaultList[1] = new DispatchRetrieverDefinition(1,"dispatch_retriever_a01","A-01","ammo",1,"dispatch_label_description_retriever_a01",10800,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",2000));
         _defaultList[2] = new DispatchRetrieverDefinition(2,"dispatch_retriever_a02","A-02","ammo",2,"dispatch_label_description_retriever_a02",21600,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",2000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[3] = new DispatchRetrieverDefinition(3,"dispatch_retriever_a03","A-03","ammo",3,"dispatch_label_description_retriever_a03",21600,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",5000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[4] = new DispatchRetrieverDefinition(4,"dispatch_retriever_a04","A-04","ammo",4,"dispatch_label_description_retriever_a04",32400,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",10000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[5] = new DispatchRetrieverDefinition(5,"dispatch_retriever_a05","A-05","ammo",5,"dispatch_label_description_retriever_a05",43200,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",10000));
         _loc1_.push(new LootModule("resource_collectable_permit-plus",1));
         _defaultList[6] = new DispatchRetrieverDefinition(6,"dispatch_retriever_a06","A-06","ammo",6,"dispatch_label_description_retriever_a06",43200,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_credits",200000));
         _defaultList[7] = new DispatchRetrieverDefinition(7,"dispatch_retriever_b01","B-01","basic",1,"dispatch_label_description_retriever_b01",10800,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",2000));
         _defaultList[8] = new DispatchRetrieverDefinition(8,"dispatch_retriever_b02","B-02","basic",2,"dispatch_label_description_retriever_b02",21600,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",2000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[9] = new DispatchRetrieverDefinition(9,"dispatch_retriever_b03","B-03","basic",3,"dispatch_label_description_retriever_b03",21600,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",5000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[10] = new DispatchRetrieverDefinition(10,"dispatch_retriever_b04","B-04","basic",4,"dispatch_label_description_retriever_b04",32400,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",10000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[11] = new DispatchRetrieverDefinition(11,"dispatch_retriever_b05","B-05","basic",5,"dispatch_label_description_retriever_b05",43200,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",10000));
         _loc1_.push(new LootModule("resource_collectable_permit-plus",1));
         _defaultList[12] = new DispatchRetrieverDefinition(12,"dispatch_retriever_b06","B-06","basic",6,"dispatch_label_description_retriever_b06",43200,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",5000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[19] = new DispatchRetrieverDefinition(19,"dispatch_retriever_h03","H-03","hitac",3,"dispatch_label_description_retriever_h03",18000,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",10000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[20] = new DispatchRetrieverDefinition(20,"dispatch_retriever_h04","H-04","hitac",4,"dispatch_label_description_retriever_h04",25200,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",15000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[21] = new DispatchRetrieverDefinition(21,"dispatch_retriever_h05","H-05","hitac",5,"dispatch_label_description_retriever_h05",32400,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_credits",200000));
         _defaultList[13] = new DispatchRetrieverDefinition(13,"dispatch_retriever_r01","R-01","resource",1,"dispatch_label_description_retriever_r01",10800,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",2000));
         _defaultList[14] = new DispatchRetrieverDefinition(14,"dispatch_retriever_r02","R-02","resource",2,"dispatch_label_description_retriever_r02",21600,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",2000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[15] = new DispatchRetrieverDefinition(15,"dispatch_retriever_r03","R-03","resource",3,"dispatch_label_description_retriever_r03",21600,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",5000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[16] = new DispatchRetrieverDefinition(16,"dispatch_retriever_r04","R-04","resource",4,"dispatch_label_description_retriever_r04",32400,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",10000));
         _loc1_.push(new LootModule("resource_collectable_permit",1));
         _defaultList[17] = new DispatchRetrieverDefinition(17,"dispatch_retriever_r05","R-05","resource",5,"dispatch_label_description_retriever_r05",43200,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
         _loc1_ = new Vector.<LootModule>(0);
         _loc1_.push(new LootModule("currency_uridium",10000));
         _loc1_.push(new LootModule("resource_collectable_permit-plus",1));
         _defaultList[18] = new DispatchRetrieverDefinition(18,"dispatch_retriever_r06","R-06","resource",6,"dispatch_label_description_retriever_r06",43200,_loc1_,new LootModule("resource_collectable_quickcoupon",1));
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get iconId() : String
      {
         return this._iconId;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get tier() : int
      {
         return this._tier;
      }
      
      public function get duration() : int
      {
         return this._duration;
      }
      
      public function get sendCost() : Vector.<LootModule>
      {
         return this._sendCost;
      }
      
      public function get instantCost() : LootModule
      {
         return this._instantCost;
      }
   }
}

