package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIWindowActionCommand implements IModule
   {
      
      private static var _instance:UIWindowActionCommand;
      
      public var windowActions:Vector.<UIWindowActionModule>;
      
      public function UIWindowActionCommand(param1:Vector.<UIWindowActionModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.windowActions = new Vector.<UIWindowActionModule>();
         }
         else
         {
            this.windowActions = param1;
         }
      }
      
      public static function get instance() : UIWindowActionCommand
      {
         return _instance || (_instance = new UIWindowActionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 122;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:UIWindowActionModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.windowActions.length > 0)
         {
            this.windowActions.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = UIWindowActionModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.windowActions.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:UIWindowActionModule = null;
         param1.writeShort(122);
         param1.writeByte(this.windowActions.length);
         for each(_loc2_ in this.windowActions)
         {
            _loc2_.write(param1);
         }
      }
   }
}

