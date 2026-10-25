package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LMLootCollectedCommand implements IModule
   {
      
      private static var _instance:LMLootCollectedCommand;
      
      public var priorityMode:LogMessengerPriorityModule;
      
      public var lootId:String = "";
      
      public var collectedAmount:int = 0;
      
      public function LMLootCollectedCommand(param1:LogMessengerPriorityModule = null, param2:String = "", param3:int = 0)
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
         this.lootId = param2;
         this.collectedAmount = param3;
      }
      
      public static function get instance() : LMLootCollectedCommand
      {
         return _instance || (_instance = new LMLootCollectedCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 214;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.priorityMode = LogMessengerPriorityModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.priorityMode)
         {
            this.priorityMode.read(param1);
         }
         this.lootId = param1.readUTF();
         this.collectedAmount = param1.readInt();
         this.collectedAmount = this.collectedAmount << 8 % 32 | this.collectedAmount >>> 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(214);
         if(null != this.priorityMode)
         {
            this.priorityMode.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.lootId);
         param1.writeInt(this.collectedAmount >>> 8 % 32 | this.collectedAmount << 32 - 8 % 32);
      }
   }
}

