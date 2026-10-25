package net.bigpoint.darkorbit.mvc.booster.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.core.data.ICollection;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.booster.model.boosterItems.BoosterItem;
   import net.bigpoint.darkorbit.mvc.booster.model.boosterItems.PlayerBoosterItem;
   import net.bigpoint.darkorbit.utils.VectorUtils;
   import org.as3commons.lang.StringUtils;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class BoosterCategory
   {
      
      private var _category:String;
      
      private var _totalPercent:Number = 0;
      
      public const changed:ISignal = new Signal();
      
      private const _activeBooster:Vector.<BoosterItem> = new Vector.<BoosterItem>(0);
      
      private var _allBoosters:Vector.<BoosterItem>;
      
      private var _translation:String;
      
      private var _description:String;
      
      public function BoosterCategory(param1:String)
      {
         super();
         this._category = param1;
         this._translation = BPLocale.getItemInCategory("items","booster_types_" + this._category.toLowerCase() + "_name");
         this._description = this._translation + "\n \n" + BPLocale.getItemInCategory("items","booster_types_" + this._category.toLowerCase() + "_description");
      }
      
      public static function filterActives(param1:BoosterCategory, param2:int, param3:Vector.<BoosterCategory>) : Boolean
      {
         return param1.hasActiveBoosters;
      }
      
      public static function sort(param1:BoosterCategory, param2:BoosterCategory) : int
      {
         if(param1.hasActiveBoosters == param2.hasActiveBoosters)
         {
            return StringUtils.compareTo(param1.translation,param2.translation);
         }
         return param1.hasActiveBoosters ? -1 : 1;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function get translation() : String
      {
         return this._translation;
      }
      
      public function addBooster(param1:BoosterItem) : void
      {
         this._activeBooster.push(param1);
         this.changed.dispatch();
      }
      
      private function get clientPercentage() : Number
      {
         var _loc4_:BoosterItem = null;
         var _loc1_:int = int(this._activeBooster.length);
         var _loc2_:Number = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = this._activeBooster[_loc3_];
            _loc2_ += _loc4_.getPercentage(this._category);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function removeBooster(param1:String, param2:Class) : void
      {
         var _loc3_:int = this.getBoosterIndex(param1,param2);
         if(_loc3_ != -1)
         {
            this._activeBooster.splice(_loc3_,1);
            this.changed.dispatch();
         }
      }
      
      private function getBoosterIndex(param1:String, param2:Class) : int
      {
         var _loc5_:BoosterItem = null;
         var _loc3_:int = int(this._activeBooster.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this._activeBooster[_loc4_];
            if(_loc5_.item.lootID == param1 && _loc5_ is param2)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      public function get length() : uint
      {
         return this._activeBooster.length;
      }
      
      public function getAsBoosterList(param1:Boolean) : ICollection
      {
         var _loc2_:Vector.<BoosterItem> = param1 ? this._activeBooster.concat(this._allBoosters) : this._activeBooster;
         _loc2_ = VectorUtils.unique(_loc2_,BoosterItem.unique) as Vector.<BoosterItem>;
         return new VectorCollection(_loc2_.sort(BoosterItem.sort));
      }
      
      public function set allBoosters(param1:Vector.<BoosterItem>) : void
      {
         this._allBoosters = param1;
      }
      
      public function getMinimumTimer() : BindableCountDown
      {
         var _loc4_:PlayerBoosterItem = null;
         var _loc1_:BindableCountDown = null;
         var _loc2_:int = int(this._activeBooster.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._activeBooster[_loc3_] as PlayerBoosterItem;
            if(_loc4_)
            {
               if(!_loc1_)
               {
                  _loc1_ = _loc4_.countdown;
               }
               else if(_loc4_.countdown.value != 0 && _loc1_.value > _loc4_.countdown.value)
               {
                  _loc1_ = _loc4_.countdown;
               }
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function get hasActiveBoosters() : Boolean
      {
         return this.totalPercent > 0;
      }
      
      public function get activeBoostersCount() : int
      {
         return this._activeBooster.length;
      }
      
      public function get totalPercent() : Number
      {
         return this._totalPercent || this.clientPercentage;
      }
      
      public function set totalPercent(param1:Number) : void
      {
         this._totalPercent = param1;
         this.changed.dispatch();
      }
      
      public function cleanup() : void
      {
         this._activeBooster.length = 0;
         this.changed.dispatch();
      }
      
      public function get description() : String
      {
         return this._description;
      }
   }
}

