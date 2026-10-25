package net.bigpoint.darkorbit.delete_in_eic
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import mx.utils.ObjectUtil;
   import net.bigpoint.darkorbit.items.utils.ItemCategories;
   import net.bigpoint.darkorbit.items.utils.ItemFilter;
   
   public class ItemFilterSettingsVO extends EventDispatcher
   {
      
      private var _filterCategories:Dictionary;
      
      private var _type:String;
      
      private var _showEventOnly:Boolean;
      
      private var _showEventOnlyFilter:Boolean;
      
      private var _invalidate:Boolean = false;
      
      public function ItemFilterSettingsVO(param1:ItemFilter, param2:String = null)
      {
         super();
         this._type = param2;
         this.setItemFilter(param1);
         this.invalidate();
         this.selectAll = true;
         this._showEventOnly = false;
         this._showEventOnlyFilter = this._type == "ASSEMBLY";
      }
      
      private function setItemFilter(param1:ItemFilter) : void
      {
         this._filterCategories = ObjectUtil.copy(param1.categories) as Dictionary;
      }
      
      public function setFilterSelectionByCategories(param1:Vector.<String>) : void
      {
         var _loc3_:String = null;
         this.selectAll = false;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            this.selectFilterByCategory(_loc3_,true);
            _loc2_++;
         }
      }
      
      public function set selectAll(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this._filterCategories)
         {
            _loc2_.selected = param1;
         }
         this.invalidate();
      }
      
      public function set selectEvent(param1:Boolean) : void
      {
         this._showEventOnly = param1;
         this.invalidate();
      }
      
      public function getFilterSelectionByCategory(param1:String) : Boolean
      {
         var _loc2_:Object = this._filterCategories[param1];
         if(_loc2_)
         {
            return _loc2_.selected;
         }
         return false;
      }
      
      public function selectFilterByCategory(param1:String, param2:Boolean) : void
      {
         var _loc3_:Object = this._filterCategories[param1];
         if(_loc3_)
         {
            if(_loc3_.selected != param2)
            {
               _loc3_.selected = param2;
               this.invalidate();
            }
         }
      }
      
      public function areAllItemsSelected() : Boolean
      {
         var _loc2_:Object = null;
         var _loc1_:Boolean = true;
         for each(_loc2_ in this._filterCategories)
         {
            if(_loc2_)
            {
               if(_loc2_.selected == false)
               {
                  _loc1_ = false;
                  break;
               }
            }
         }
         return _loc1_;
      }
      
      public function isEventFilterSelected() : Boolean
      {
         return this._showEventOnly;
      }
      
      public function isEventFilterEnabled() : Boolean
      {
         return this._showEventOnlyFilter;
      }
      
      public function getAllSelectedItemTypes() : Dictionary
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         this.validate();
         var _loc1_:Dictionary = new Dictionary();
         for(_loc2_ in this._filterCategories)
         {
            _loc3_ = this._filterCategories[_loc2_];
            if(_loc3_.selected)
            {
               _loc4_ = ItemCategories.getItemTypesForCategoryID(_loc3_.category);
               if(_loc4_)
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_.length)
                  {
                     _loc6_ = _loc4_[_loc5_];
                     _loc1_[_loc6_] = _loc6_;
                     _loc5_++;
                  }
               }
            }
            if(_loc3_.category == "event")
            {
               this._showEventOnly = _loc3_.selected;
            }
         }
         return _loc1_;
      }
      
      public function getAllSelectedCategoriesAsVector() : Vector.<String>
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<String> = new Vector.<String>();
         for(_loc2_ in this._filterCategories)
         {
            _loc3_ = this._filterCategories[_loc2_];
            if(_loc3_.selected)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getFilterCategoriesAsSortedVector() : Vector.<Object>
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc1_:Vector.<Object> = new Vector.<Object>();
         for(_loc2_ in this._filterCategories)
         {
            _loc3_ = this._filterCategories[_loc2_];
            if(_loc3_)
            {
               _loc3_.category = _loc2_;
               _loc1_.push(_loc3_);
            }
         }
         _loc1_.sort(this.sortCategoryBehavior);
         return _loc1_;
      }
      
      protected function sortCategoryBehavior(param1:Object, param2:Object) : Number
      {
         var _loc3_:Number = 0;
         if(param1.index > param2.index)
         {
            _loc3_ = 1;
         }
         else if(param1.index < param2.index)
         {
            _loc3_ = -1;
         }
         else if(param1.index == param2.index)
         {
            _loc3_ = 0;
         }
         return _loc3_;
      }
      
      public function getFilterCategoriesAsMap() : Dictionary
      {
         return this._filterCategories;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function invalidate() : void
      {
         this._invalidate = true;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function validate() : void
      {
         this._invalidate = false;
      }
      
      public function isValidate() : Boolean
      {
         return !this._invalidate;
      }
      
      public function isInvalidate() : Boolean
      {
         return this._invalidate;
      }
   }
}

