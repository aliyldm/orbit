package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class NpcEventInfoCommand implements IModule
   {
      
      private static var _instance:NpcEventInfoCommand;
      
      public static const WINDOWTYPE_STANDARD:int = 0;
      
      public static const WINDOWTYPE_STANDARD_NO_BOSS:int = 1;
      
      public static const WINDOWTYPE_NO_WINDOW:int = 2;
      
      public static const WINDOWTYPE__MAX:int = 3;
      
      public var textKey:String = "";
      
      public var type:int = 0;
      
      public var bossInfoCommand:NpcEventBossInfoCommand;
      
      public var timeInfoCommand:NpcEventTimeInfoCommand;
      
      public var npcID:int = 0;
      
      public function NpcEventInfoCommand(param1:int = 0, param2:String = "", param3:int = 0, param4:NpcEventTimeInfoCommand = null, param5:NpcEventBossInfoCommand = null)
      {
         super();
         this.textKey = param2;
         this.type = param1;
         if(param5 == null)
         {
            this.bossInfoCommand = new NpcEventBossInfoCommand();
         }
         else
         {
            this.bossInfoCommand = param5;
         }
         if(param4 == null)
         {
            this.timeInfoCommand = new NpcEventTimeInfoCommand();
         }
         else
         {
            this.timeInfoCommand = param4;
         }
         this.npcID = param3;
      }
      
      public static function get instance() : NpcEventInfoCommand
      {
         return _instance || (_instance = new NpcEventInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -26622;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.textKey = param1.readUTF();
         this.type = param1.readShort();
         this.bossInfoCommand = NpcEventBossInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.bossInfoCommand)
         {
            this.bossInfoCommand.read(param1);
         }
         this.timeInfoCommand = NpcEventTimeInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.timeInfoCommand)
         {
            this.timeInfoCommand.read(param1);
         }
         this.npcID = param1.readInt();
         this.npcID = this.npcID >>> 1 % 32 | this.npcID << 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-26622);
         param1.writeUTF(this.textKey);
         param1.writeShort(this.type);
         if(null != this.bossInfoCommand)
         {
            this.bossInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.timeInfoCommand)
         {
            this.timeInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.npcID << 1 % 32 | this.npcID >>> 32 - 1 % 32);
      }
   }
}

