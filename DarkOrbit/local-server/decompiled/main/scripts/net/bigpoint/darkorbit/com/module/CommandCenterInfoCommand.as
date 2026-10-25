package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CommandCenterInfoCommand implements IModule
   {
      
      private static var _instance:CommandCenterInfoCommand;
      
      public var ids:Vector.<CommandCenterNewsModule>;
      
      public function CommandCenterInfoCommand(param1:Vector.<CommandCenterNewsModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.ids = new Vector.<CommandCenterNewsModule>();
         }
         else
         {
            this.ids = param1;
         }
      }
      
      public static function get instance() : CommandCenterInfoCommand
      {
         return _instance || (_instance = new CommandCenterInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5593;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CommandCenterNewsModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.ids.length > 0)
         {
            this.ids.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CommandCenterNewsModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.ids.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CommandCenterNewsModule = null;
         param1.writeShort(5593);
         param1.writeByte(this.ids.length);
         for each(_loc2_ in this.ids)
         {
            _loc2_.write(param1);
         }
      }
   }
}

