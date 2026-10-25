package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuestInfoCommand implements IModule
   {
      
      private static var _instance:QuestInfoCommand;
      
      public var definition:QuestDefinitionModule;
      
      public var ratings:Vector.<QuestChallengeRatingModule>;
      
      public var playersRating:QuestChallengeRatingModule;
      
      public function QuestInfoCommand(param1:QuestDefinitionModule = null, param2:Vector.<QuestChallengeRatingModule> = null, param3:QuestChallengeRatingModule = null)
      {
         super();
         if(param1 == null)
         {
            this.definition = new QuestDefinitionModule();
         }
         else
         {
            this.definition = param1;
         }
         if(param2 == null)
         {
            this.ratings = new Vector.<QuestChallengeRatingModule>();
         }
         else
         {
            this.ratings = param2;
         }
         if(param3 == null)
         {
            this.playersRating = new QuestChallengeRatingModule();
         }
         else
         {
            this.playersRating = param3;
         }
      }
      
      public static function get instance() : QuestInfoCommand
      {
         return _instance || (_instance = new QuestInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2090;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:QuestChallengeRatingModule = null;
         this.definition = QuestDefinitionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.definition)
         {
            this.definition.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.ratings.length > 0)
         {
            this.ratings.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = QuestChallengeRatingModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.ratings.push(_loc4_);
            _loc2_++;
         }
         this.playersRating = QuestChallengeRatingModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.playersRating)
         {
            this.playersRating.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:QuestChallengeRatingModule = null;
         param1.writeShort(2090);
         if(null != this.definition)
         {
            this.definition.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.ratings.length);
         for each(_loc2_ in this.ratings)
         {
            _loc2_.write(param1);
         }
         if(null != this.playersRating)
         {
            this.playersRating.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

