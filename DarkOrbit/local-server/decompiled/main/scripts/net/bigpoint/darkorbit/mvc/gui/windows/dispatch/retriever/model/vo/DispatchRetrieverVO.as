package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model.vo
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.DispatchModule;
   import net.bigpoint.darkorbit.com.module.LootModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model.DispatchRetrieverDefinition;
   import org.as3commons.lang.StringUtils;
   import org.osflash.signals.ISignal;
   
   public class DispatchRetrieverVO
   {
      
      private var _changedSignal:ISignal;
      
      private var _dispatchModule:DispatchModule;
      
      private var _retrieverDefinition:DispatchRetrieverDefinition;
      
      private var _isAvailable:Boolean;
      
      public function DispatchRetrieverVO()
      {
         super();
      }
      
      public static function sort(param1:DispatchRetrieverVO, param2:DispatchRetrieverVO) : int
      {
         if(param1.name == param2.name)
         {
            return param1.tier - param2.tier;
         }
         return StringUtils.compareTo(param1.name,param2.name);
      }
      
      public function get id() : int
      {
         return this._dispatchModule.id;
      }
      
      public function get iconId() : String
      {
         return this._retrieverDefinition.iconId;
      }
      
      public function get typeId() : int
      {
         return Math.round((this._dispatchModule.id - 1) / 6);
      }
      
      public function get type() : String
      {
         return this._retrieverDefinition.type;
      }
      
      public function get name() : String
      {
         return this._retrieverDefinition.name;
      }
      
      public function get description() : String
      {
         return this._retrieverDefinition.description;
      }
      
      public function get tier() : int
      {
         return this._retrieverDefinition.tier;
      }
      
      public function get duration() : int
      {
         return this._dispatchModule.duration;
      }
      
      public function get defaultDuration() : int
      {
         return this._retrieverDefinition.duration;
      }
      
      public function get costList() : Vector.<LootModule>
      {
         return this._retrieverDefinition.sendCost;
      }
      
      public function get changedSignal() : ISignal
      {
         return this._changedSignal;
      }
      
      public function set changedSignal(param1:ISignal) : void
      {
         this._changedSignal = param1;
      }
      
      public function get dispatchModule() : DispatchModule
      {
         return this._dispatchModule;
      }
      
      public function set dispatchModule(param1:DispatchModule) : void
      {
         this._dispatchModule = param1;
         this._retrieverDefinition = DispatchRetrieverDefinition.getRetrieverDefinition(param1.id);
      }
      
      public function get isAvailable() : Boolean
      {
         return this._isAvailable;
      }
      
      public function set isAvailable(param1:Boolean) : void
      {
         this._isAvailable = param1;
      }
      
      public function costListToString() : String
      {
         var _loc5_:LootModule = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         if(this._retrieverDefinition == null)
         {
            return "";
         }
         var _loc1_:String = "";
         var _loc2_:Vector.<LootModule> = this._retrieverDefinition.sendCost;
         var _loc3_:uint = _loc2_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc6_ = ItemDataProviderHelper.getItem(_loc5_.lootId).fullname;
            _loc7_ = TextFormatter.roundInteger(_loc5_.amount);
            _loc1_ += BPLocale.getItemInCategory("base","dispatch_generic-itemlabel").replace("%LOOTID%",_loc6_).replace("%AMOUNT%",_loc7_);
            if(_loc4_ != _loc3_ - 1)
            {
               _loc1_ += "\n";
            }
            _loc4_++;
         }
         return _loc1_;
      }
   }
}

