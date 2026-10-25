package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestGiverModule implements IModule
   {
      
      private static var _instance:QuestGiverModule;
      
      public var questGiverId:int = 0;
      
      public var mapObjectId:int = 0;
      
      public var toolTip:MessageKeyListWildcardCommand;
      
      public function QuestGiverModule(param1:int = 0, param2:int = 0, param3:MessageKeyListWildcardCommand = null)
      {
         super();
         this.questGiverId = param1;
         this.mapObjectId = param2;
         if(param3 == null)
         {
            this.toolTip = new MessageKeyListWildcardCommand();
         }
         else
         {
            this.toolTip = param3;
         }
      }
      
      public static function get instance() : QuestGiverModule
      {
         return _instance || (_instance = new QuestGiverModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2085;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questGiverId = param1.readInt();
         this.questGiverId = this.questGiverId << 12 % 32 | this.questGiverId >>> 32 - 12 % 32;
         this.mapObjectId = param1.readInt();
         this.mapObjectId = this.mapObjectId >>> 5 % 32 | this.mapObjectId << 32 - 5 % 32;
         this.toolTip = MessageKeyListWildcardCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.toolTip)
         {
            this.toolTip.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2085);
         param1.writeInt(this.questGiverId >>> 12 % 32 | this.questGiverId << 32 - 12 % 32);
         param1.writeInt(this.mapObjectId << 5 % 32 | this.mapObjectId >>> 32 - 5 % 32);
         if(null != this.toolTip)
         {
            this.toolTip.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

