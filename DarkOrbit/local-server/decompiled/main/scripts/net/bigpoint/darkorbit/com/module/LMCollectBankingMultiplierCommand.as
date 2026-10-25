package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMCollectBankingMultiplierCommand implements IModule
   {
      
      private static var _instance:LMCollectBankingMultiplierCommand;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var factor:int = 0;
      
      public function LMCollectBankingMultiplierCommand(param1:LogMessengerPriorityModule = null, param2:int = 0)
      {
         super();
         if(param1 == null)
         {
            this.priorityMode = new LogMessengerPriorityModule();
         }
         else
         {
            this.priorityMode = param1;
         }
         this.factor = param2;
      }
      
      public static function get instance() : LMCollectBankingMultiplierCommand
      {
         return _instance || (_instance = new LMCollectBankingMultiplierCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 211;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priorityMode = LogMessengerPriorityModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.priorityMode)
         {
            this.priorityMode.read(param1);
         }
         this.factor = param1.readInt();
         this.factor = this.factor << 16 % 32 | this.factor >>> 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(211);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.factor >>> 16 % 32 | this.factor << 32 - 16 % 32);
      }
   }
}

