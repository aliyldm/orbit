package net.bigpoint.darkorbit.mvc.commandCenter.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.repo.CommandCenterNewsDefinition;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.repo.CommandCenterNewsRepository;
   import org.osflash.signals.Signal;
   
   public class CommandCenterModel
   {
      
      public static const NORMAL_STATE:int = 0;
      
      public static const UNREAD_NEWS_STATE:int = 1;
      
      public static const UNREAD_DEALS_STATE:int = 2;
      
      public const hasNews:BindableBoolean = new BindableBoolean(false);
      
      public const categoriesChanged:Signal = new Signal();
      
      public const state:BindableInt = new BindableInt(NORMAL_STATE);
      
      public const dontShowInfoReturned:Signal = new Signal(Boolean);
      
      private var _news:Vector.<CommandCenterNewsVO> = new Vector.<CommandCenterNewsVO>(0);
      
      private var _newsRepository:CommandCenterNewsRepository = new CommandCenterNewsRepository();
      
      private var _newsByKey:Object = {};
      
      private var _categories:Vector.<CommandCenterCategory> = new Vector.<CommandCenterCategory>(0);
      
      private var _invalidStatePointer:uint;
      
      private var _dontShowChecked:Boolean;
      
      public function CommandCenterModel()
      {
         super();
      }
      
      public function get news() : Vector.<CommandCenterNewsVO>
      {
         return this._news;
      }
      
      public function get categories() : Vector.<CommandCenterCategory>
      {
         return this._categories;
      }
      
      public function get newsRepository() : CommandCenterNewsRepository
      {
         return this._newsRepository;
      }
      
      public function get specialCategory() : CommandCenterCategory
      {
         var _loc3_:CommandCenterCategory = null;
         var _loc1_:int = int(this._categories.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this._categories[_loc2_];
            if(_loc3_.isSpecial)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function addNews(param1:CommandCenterNewsDefinition, param2:Number) : CommandCenterNewsVO
      {
         var _loc3_:CommandCenterNewsVO = this.internalGetByKey(param1.name);
         if(!_loc3_)
         {
            _loc3_ = this.internalAdd(param1,param2);
            this.invalidateState(1000);
         }
         else
         {
            _loc3_.updateTimeLeft(param2);
         }
         return _loc3_;
      }
      
      public function removeNewsByNewsId(param1:String) : void
      {
         this.internalRemove(param1);
      }
      
      public function getNewsByKey(param1:String) : CommandCenterNewsVO
      {
         return this.internalGetByKey(param1);
      }
      
      public function updateViewCount(param1:String, param2:int) : void
      {
         var _loc3_:CommandCenterNewsVO = this.getNewsByKey(param1);
         if(_loc3_)
         {
            _loc3_.clickCount = param2;
         }
         this.invalidateState();
      }
      
      private function invalidateState(param1:Number = 10) : void
      {
         clearTimeout(this._invalidStatePointer);
         this._invalidStatePointer = setTimeout(this.calculateState,param1);
      }
      
      private function calculateState() : void
      {
         var _loc4_:CommandCenterCategory = null;
         var _loc1_:int = int(this._categories.length);
         var _loc2_:int = NORMAL_STATE;
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc4_ = this._categories[_loc3_];
            if(_loc4_.isSpecial && _loc4_.hasUnreadNews.value == true)
            {
               _loc2_ = UNREAD_DEALS_STATE;
               break;
            }
            if(_loc4_.hasUnreadNews.value == true)
            {
               _loc2_ = UNREAD_NEWS_STATE;
            }
            _loc3_++;
         }
         this.state.value = _loc2_;
      }
      
      private function internalGetByKey(param1:String) : CommandCenterNewsVO
      {
         return this._newsByKey[param1];
      }
      
      private function getOrAddCategory(param1:String) : CommandCenterCategory
      {
         var _loc2_:CommandCenterCategory = this.getCategory(param1);
         if(!_loc2_)
         {
            _loc2_ = new CommandCenterCategory(this._newsRepository.getCategoryDefinition(param1));
            _loc2_.hasUnreadNews.changed.add(this.updateHasNews);
            this._categories.push(_loc2_);
            this.categoriesChanged.dispatch();
         }
         return _loc2_;
      }
      
      private function updateHasNews() : void
      {
         var _loc4_:CommandCenterCategory = null;
         var _loc1_:Boolean = false;
         var _loc2_:int = int(this._categories.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._categories[_loc3_];
            _loc1_ ||= _loc4_.hasUnreadNews.value;
            if(_loc1_)
            {
               break;
            }
            _loc3_++;
         }
         this.hasNews.value = _loc1_;
         this.invalidateState();
      }
      
      internal function getCategory(param1:String) : CommandCenterCategory
      {
         var _loc4_:CommandCenterCategory = null;
         var _loc2_:int = int(this._categories.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._categories[_loc3_];
            if(_loc4_.id == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function internalAdd(param1:CommandCenterNewsDefinition, param2:Number) : CommandCenterNewsVO
      {
         var _loc3_:CommandCenterNewsVO = new CommandCenterNewsVO(param1);
         _loc3_.updateTimeLeft(param2);
         this._news.push(_loc3_);
         this._newsByKey[_loc3_.key] = _loc3_;
         var _loc4_:CommandCenterCategory = this.getOrAddCategory(_loc3_.data.category);
         _loc4_.add(_loc3_);
         return _loc3_;
      }
      
      private function internalRemove(param1:String) : void
      {
         var _loc2_:CommandCenterNewsVO = this.internalGetByKey(param1);
         if(_loc2_)
         {
            this._news.splice(this._news.indexOf(_loc2_),1);
            delete this._newsByKey[param1];
            this.removeFromCategory(_loc2_);
         }
      }
      
      private function removeFromCategory(param1:CommandCenterNewsVO) : void
      {
         var _loc2_:CommandCenterCategory = this.getCategory(param1.data.category);
         if(_loc2_)
         {
            _loc2_.remove(param1);
            if(_loc2_.listOfNews.length == 0)
            {
               _loc2_.hasUnreadNews.changed.remove(this.updateHasNews);
               this._categories.splice(this._categories.indexOf(_loc2_),1);
               this.categoriesChanged.dispatch();
            }
         }
      }
      
      public function dontShowInfoReturnedUpdate(param1:Boolean) : void
      {
         this._dontShowChecked = param1;
         this.dontShowInfoReturned.dispatch(param1);
      }
      
      public function get serverDontShowChecked() : Boolean
      {
         return this._dontShowChecked;
      }
   }
}

