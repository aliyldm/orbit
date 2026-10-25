package net.bigpoint.darkorbit.mvc.commandCenter.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableSmartCountDown;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.repo.CommandCenterCategoryDefinition;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class CommandCenterCategory
   {
      
      public static const CATEGORY_SALES:String = "sales";
      
      public const changed:ISignal = new Signal();
      
      public const hasUnreadNews:BindableBoolean = new BindableBoolean(false);
      
      public const timer:BindableSmartCountDown = new BindableSmartCountDown();
      
      private var _listOfNews:Vector.<CommandCenterNewsVO> = new Vector.<CommandCenterNewsVO>(0);
      
      private var _def:CommandCenterCategoryDefinition;
      
      public function CommandCenterCategory(param1:CommandCenterCategoryDefinition)
      {
         super();
         this._def = param1;
      }
      
      public static function sort(param1:CommandCenterCategory, param2:CommandCenterCategory) : int
      {
         if(param1.isSpecial == param2.isSpecial)
         {
            return param1.prio - param2.prio;
         }
         if(param1.isSpecial)
         {
            return 1;
         }
         return -1;
      }
      
      public function get id() : String
      {
         return this._def.id;
      }
      
      public function get listOfNews() : Vector.<CommandCenterNewsVO>
      {
         return this._listOfNews;
      }
      
      public function get isSpecial() : Boolean
      {
         return this._def.isSpecial;
      }
      
      public function get textKey() : String
      {
         return this._def.textkey;
      }
      
      public function get prio() : int
      {
         return this._def.prio;
      }
      
      public function add(param1:CommandCenterNewsVO) : void
      {
         var _loc2_:Number = this._listOfNews.indexOf(param1);
         if(_loc2_ == -1)
         {
            param1.isNew.changed.add(this.updateUnreadNews);
            param1.refreshed.add(this.updateLowestTimer);
            this._listOfNews.push(param1);
            this._listOfNews.sort(CommandCenterNewsVO.sort);
            this.changed.dispatch();
         }
         this.updateUnreadNews();
         this.updateLowestTimer();
      }
      
      public function remove(param1:CommandCenterNewsVO) : void
      {
         var _loc2_:Number = this._listOfNews.indexOf(param1);
         if(_loc2_ != -1)
         {
            param1.isNew.changed.remove(this.updateUnreadNews);
            param1.refreshed.remove(this.updateLowestTimer);
            this._listOfNews.splice(_loc2_,1);
            this.changed.dispatch();
         }
         this.updateUnreadNews();
         this.updateLowestTimer();
      }
      
      public function getSpecialText(param1:int) : String
      {
         var _loc2_:CommandCenterNewsVO = null;
         if(this._listOfNews.length > param1)
         {
            _loc2_ = this._listOfNews[param1];
            return _loc2_.data.categoryOverrideKey ? BPLocale.getItemInCategory("bn",_loc2_.data.categoryOverrideKey) : null;
         }
         return null;
      }
      
      private function updateUnreadNews() : void
      {
         var _loc4_:CommandCenterNewsVO = null;
         var _loc1_:int = int(this._listOfNews.length);
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = this._listOfNews[_loc3_];
            _loc2_ ||= _loc4_.isNew.value;
            _loc3_++;
         }
         this.hasUnreadNews.value = _loc2_;
      }
      
      private function updateLowestTimer() : void
      {
         var _loc4_:CommandCenterNewsVO = null;
         var _loc1_:int = int(this._listOfNews.length);
         var _loc2_:Number = int.MAX_VALUE;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = this._listOfNews[_loc3_];
            if(_loc4_.timer.value > 0)
            {
               _loc2_ = Math.min(_loc2_,_loc4_.timer.value);
            }
            _loc3_++;
         }
         if(_loc2_ != int.MAX_VALUE)
         {
            this.timer.value = _loc2_;
         }
      }
   }
}

