package net.bigpoint.darkorbit.fui.builder.repository
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   
   public class UIInstanceRepository
   {
      
      private static var repositoryInstances:Dictionary = new Dictionary();
      
      private static var _defaultModuleName:String = Coreponent.DEFAULT_MODULE_NAME;
      
      private var _instances:Dictionary = new Dictionary();
      
      private var _moduleName:String;
      
      public function UIInstanceRepository(param1:String)
      {
         super();
         this._moduleName = param1;
      }
      
      public static function getInstance(param1:String = null) : UIInstanceRepository
      {
         param1 = param1 != null ? param1 : defaultModuleName;
         var _loc2_:UIInstanceRepository = repositoryInstances[param1];
         if(_loc2_ == null)
         {
            repositoryInstances[param1] = new UIInstanceRepository(param1);
         }
         return repositoryInstances[param1];
      }
      
      public static function getICoreponentInstance(param1:String, param2:String = null) : ICoreponent
      {
         var _loc3_:ICoreponent = null;
         param2 = param2 ? param2 : defaultModuleName;
         var _loc4_:UIInstanceRepository = UIInstanceRepository.getInstance(param2);
         if(_loc4_)
         {
            return _loc4_.getICoreponentInstance(param1);
         }
         throw new Error("Tried to get a coreponent instance form a module with the name = " + param2 + ". This module doesn´t exists.");
      }
      
      public static function set defaultModuleName(param1:String) : void
      {
         _defaultModuleName = param1;
      }
      
      public static function get defaultModuleName() : String
      {
         return _defaultModuleName;
      }
      
      public static function clearDefaultModuleNaming() : void
      {
         _defaultModuleName = Coreponent.DEFAULT_MODULE_NAME;
      }
      
      public function getICoreponentInstance(param1:String) : ICoreponent
      {
         return this._instances[param1];
      }
      
      public function register(param1:ICoreponent) : Boolean
      {
         if(!this.instanceExist(param1))
         {
            param1.moduleName = this._moduleName;
            this._instances[param1.name] = param1;
            return true;
         }
         param1.moduleName = this._moduleName;
         this._instances[param1.name] = param1;
         return false;
      }
      
      public function unregister(param1:ICoreponent) : Boolean
      {
         if(this.instanceExist(param1))
         {
            this._instances[param1.name] = null;
            delete this._instances[param1.name];
            return true;
         }
         return false;
      }
      
      public function toString() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         _loc1_ += this._moduleName + " -------------------------------------\n";
         for(_loc2_ in this._instances)
         {
            _loc1_ += _loc2_ + "\n";
         }
         return _loc1_;
      }
      
      protected function instanceExist(param1:ICoreponent) : Boolean
      {
         return this._instances[param1.name] != null;
      }
   }
}

