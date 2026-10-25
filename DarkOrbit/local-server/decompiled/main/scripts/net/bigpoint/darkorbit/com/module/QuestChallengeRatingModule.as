package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestChallengeRatingModule implements IModule
   {
      
      private static var _instance:QuestChallengeRatingModule;
      
      public var name:String = "";
      
      public var epppLink:String = "";
      
      public var rank:int = 0;
      
      public var rating:int = 0;
      
      public var diffToFirst:int = 0;
      
      public function QuestChallengeRatingModule(param1:String = "", param2:String = "", param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.name = param1;
         this.epppLink = param2;
         this.rank = param3;
         this.rating = param4;
         this.diffToFirst = param5;
      }
      
      public static function get instance() : QuestChallengeRatingModule
      {
         return _instance || (_instance = new QuestChallengeRatingModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4321;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.name = param1.readUTF();
         this.epppLink = param1.readUTF();
         this.rank = param1.readInt();
         this.rank = this.rank >>> 13 % 32 | this.rank << 32 - 13 % 32;
         this.rating = param1.readInt();
         this.rating = this.rating << 15 % 32 | this.rating >>> 32 - 15 % 32;
         this.diffToFirst = param1.readInt();
         this.diffToFirst = this.diffToFirst << 7 % 32 | this.diffToFirst >>> 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4321);
         param1.writeUTF(this.name);
         param1.writeUTF(this.epppLink);
         param1.writeInt(this.rank << 13 % 32 | this.rank >>> 32 - 13 % 32);
         param1.writeInt(this.rating >>> 15 % 32 | this.rating << 32 - 15 % 32);
         param1.writeInt(this.diffToFirst >>> 7 % 32 | this.diffToFirst << 32 - 7 % 32);
      }
   }
}

