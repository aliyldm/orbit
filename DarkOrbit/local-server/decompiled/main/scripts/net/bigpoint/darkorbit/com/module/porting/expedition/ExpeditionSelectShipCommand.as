package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class ExpeditionSelectShipCommand implements IModule
   {
      
      private static var _instance:ExpeditionSelectShipCommand;
      
      public var stack:BaseStackCommand;
      
      public var result:Boolean = false;
      
      public function ExpeditionSelectShipCommand(param1:Boolean = false, param2:BaseStackCommand = null)
      {
         super();
         if(param2 == null)
         {
            this.stack = new BaseStackCommand();
         }
         else
         {
            this.stack = param2;
         }
         this.result = param1;
      }
      
      public static function get instance() : ExpeditionSelectShipCommand
      {
         return _instance || (_instance = new ExpeditionSelectShipCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -9940;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.stack = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.stack)
         {
            this.stack.read(param1);
         }
         this.result = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-9940);
         if(null != this.stack)
         {
            this.stack.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.result);
      }
   }
}

