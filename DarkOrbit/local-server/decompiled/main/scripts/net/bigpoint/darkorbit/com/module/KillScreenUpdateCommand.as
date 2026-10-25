package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class KillScreenUpdateCommand implements IModule
   {
      
      private static var _instance:KillScreenUpdateCommand;
      
      public var options:Vector.<KillScreenOptionModule>;
      
      public function KillScreenUpdateCommand(param1:Vector.<KillScreenOptionModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.options = new Vector.<KillScreenOptionModule>();
         }
         else
         {
            this.options = param1;
         }
      }
      
      public static function get instance() : KillScreenUpdateCommand
      {
         return _instance || (_instance = new KillScreenUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6777;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:KillScreenOptionModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.options.length > 0)
         {
            this.options.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = KillScreenOptionModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.options.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:KillScreenOptionModule = null;
         param1.writeShort(6777);
         param1.writeByte(this.options.length);
         for each(_loc2_ in this.options)
         {
            _loc2_.write(param1);
         }
      }
   }
}

