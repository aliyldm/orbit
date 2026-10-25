package net.bigpoint.darkorbit.items.utils
{
   import flash.utils.Dictionary;
   
   public class ItemFilter
   {
      
      private static const _itemFilters:Array = [];
      
      private static var _initialize:Boolean = false;
      
      public static const FILTER_TYPE_EQUIPMENT:String = "equipment";
      
      public static const FILTER_TYPE_SHOP:String = "shop";
      
      public static const FILTER_TYPE_ASSEMBLY:String = "assembly";
      
      public static const FILTER_TYPE_UPGRADE:String = "upgrade";
      
      public static const FILTER_TYPE_BATTLEPASS:String = "battlepass";
      
      public static const FILTER_TYPE_EQUIPMENT_PRESET_FILTER_SHIPS:String = "equipment.filter_ships";
      
      public static const FILTER_TYPE_EQUIPMENT_PRESET_FILTER_DRONES:String = "equipment.filter_drones";
      
      public static const FILTER_TYPE_EQUIPMENT_PRESET_FILTER_PET:String = "equipment.filter_pet";
      
      public static const FILTER_TYPE_SHOP_PRESET_FILTER_SHIPS:String = "shop.filter_ships";
      
      public static const FILTER_TYPE_ASSEMBLY_PRESET_DEFAULT:String = "assembly.default";
      
      public static const FILTER_TYPE_UPGRADE_PRESET_DEFAULT:String = "upgrade.default";
      
      public static const FILTER_TYPE_BATTLEPASS_PRESET_DEFAULT:String = "battlepass.default";
      
      private var _categoryIndex:uint = 0;
      
      private var _type:String;
      
      private var _categories:Dictionary = new Dictionary();
      
      private var _filterSets:Dictionary = new Dictionary();
      
      public function ItemFilter(param1:String)
      {
         super();
         this._type = param1;
      }
      
      public static function getFilterByType(param1:String) : ItemFilter
      {
         initialize();
         return _itemFilters[param1];
      }
      
      public static function initialize() : void
      {
         var _loc1_:ItemFilter = null;
         var _loc2_:Array = null;
         if(_initialize)
         {
            return;
         }
         _initialize = true;
         _loc1_ = new ItemFilter("equipment");
         _loc1_.setCategory("ammunition");
         _loc1_.setCategory("drones");
         _loc1_.setCategory("extras");
         _loc1_.setCategory("generators");
         _loc1_.setCategory("ships");
         _loc1_.setCategory("modules");
         _loc1_.setCategory("pet.gear");
         _loc1_.setCategory("pet.protocols");
         _loc1_.setCategory("resources");
         _loc1_.setCategory("weapons");
         _loc2_ = [];
         _loc2_.push("weapon");
         _loc2_.push("generator");
         _loc2_.push("extras");
         _loc1_.addFilterSet("filter_ships",_loc2_);
         _loc2_ = [];
         _loc2_.push("weapon");
         _loc2_.push("generator");
         _loc2_.push("extras");
         _loc1_.addFilterSet("filter_drones",_loc2_);
         _loc2_ = [];
         _loc2_.push("weapon");
         _loc2_.push("generator");
         _loc2_.push("extras");
         _loc2_.push("pet.gear");
         _loc2_.push("pet.protocols");
         _loc1_.addFilterSet("filter_pet",_loc2_);
         _itemFilters["equipment"] = _loc1_;
         _loc1_ = new ItemFilter("shop");
         _loc1_.setCategory("ammunition");
         _loc1_.setCategory("drones");
         _loc1_.setCategory("extras");
         _loc2_ = [];
         _loc2_.push("weapon");
         _loc2_.push("generator");
         _loc2_.push("extras");
         _loc1_.addFilterSet("filter_ships",_loc2_);
         _itemFilters["shop"] = _loc1_;
         _loc1_ = new ItemFilter("assembly");
         _loc1_.setCategory("ships_and_designs");
         _loc1_.setCategory("ammunition");
         _loc1_.setCategory("weapons");
         _loc1_.setCategory("pet");
         _loc1_.setCategory("generators");
         _loc1_.setCategory("drones");
         _loc1_.setCategory("extras");
         _loc1_.setCategory("boosters");
         _loc1_.setCategory("hardware");
         _loc1_.setCategory("modules");
         _loc1_.setCategory("techs");
         _loc2_ = [];
         _loc2_.push("ships_and_designs");
         _loc2_.push("ammunition");
         _loc2_.push("weapons");
         _loc2_.push("pet");
         _loc2_.push("generators");
         _loc2_.push("drones");
         _loc2_.push("extras");
         _loc2_.push("boosters");
         _loc2_.push("hardware");
         _loc2_.push("modules");
         _loc2_.push("techs");
         _loc1_.addFilterSet("default",_loc2_);
         _itemFilters["assembly"] = _loc1_;
         _loc1_ = new ItemFilter("upgrade");
         _loc1_.setCategory("weapons");
         _loc1_.setCategory("generators");
         _loc1_.setCategory("drones");
         _loc1_.setCategory("modules");
         _loc2_ = [];
         _loc2_.push("weapons");
         _loc2_.push("generators");
         _loc2_.push("drones");
         _loc2_.push("modules");
         _loc1_.addFilterSet("default",_loc2_);
         _itemFilters["upgrade"] = _loc1_;
         _loc1_ = new ItemFilter("battlepass");
         _loc1_.setCategory("special");
         _loc1_.setCategory("standard");
         _loc2_ = [];
         _loc2_.push("special");
         _loc2_.push("standard");
         _loc1_.addFilterSet("default",_loc2_);
         _itemFilters["battlepass"] = _loc1_;
      }
      
      public function get filter() : String
      {
         return this._type;
      }
      
      protected function setCategory(param1:String) : void
      {
         ++this._categoryIndex;
         this._categories[param1] = {"index":this._categoryIndex};
      }
      
      public function get categories() : Dictionary
      {
         return this._categories;
      }
      
      public function addFilterSet(param1:String, param2:Array) : void
      {
         this._filterSets[param1] = param2;
      }
      
      public function getFilterSet(param1:String) : Array
      {
         return this._filterSets[param1];
      }
   }
}

