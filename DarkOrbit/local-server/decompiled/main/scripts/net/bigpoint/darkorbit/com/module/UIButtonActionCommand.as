package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIButtonActionCommand implements IModule
   {
      
      private static var _instance:UIButtonActionCommand;
      
      public var buttonActions:Vector.<UIButtonActionModule>;
      
      public function UIButtonActionCommand(param1:Vector.<UIButtonActionModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.buttonActions = new Vector.<UIButtonActionModule>();
         }
         else
         {
            this.buttonActions = param1;
         }
      }
      
      public static function get instance() : UIButtonActionCommand
      {
         return _instance || (_instance = new UIButtonActionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 126;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:UIButtonActionModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.buttonActions.length > 0)
         {
            this.buttonActions.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = UIButtonActionModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.buttonActions.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:UIButtonActionModule = null;
         param1.writeShort(126);
         param1.writeByte(this.buttonActions.length);
         for each(_loc2_ in this.buttonActions)
         {
            _loc2_.write(param1);
         }
      }
   }
}

