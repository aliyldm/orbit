package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMCollectCreditsCommand implements IModule
   {
      
      private static var _instance:LMCollectCreditsCommand;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var collectedAmount:int = 0;
      
      public var summedAmount:int = 0;
      
      public function LMCollectCreditsCommand(param1:LogMessengerPriorityModule = null, param2:int = 0, param3:int = 0)
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
         this.collectedAmount = param2;
         this.summedAmount = param3;
      }
      
      public static function get instance() : LMCollectCreditsCommand
      {
         return _instance || (_instance = new LMCollectCreditsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 206;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priorityMode = LogMessengerPriorityModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.priorityMode)
         {
            this.priorityMode.read(param1);
         }
         this.collectedAmount = param1.readInt();
         this.collectedAmount = this.collectedAmount << 9 % 32 | this.collectedAmount >>> 32 - 9 % 32;
         this.summedAmount = param1.readInt();
         this.summedAmount = this.summedAmount >>> 3 % 32 | this.summedAmount << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(206);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.collectedAmount >>> 9 % 32 | this.collectedAmount << 32 - 9 % 32);
         param1.writeInt(this.summedAmount << 3 % 32 | this.summedAmount >>> 32 - 3 % 32);
      }
   }
}

