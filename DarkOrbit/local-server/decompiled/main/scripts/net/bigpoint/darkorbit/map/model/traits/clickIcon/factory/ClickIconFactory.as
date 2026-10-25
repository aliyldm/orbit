package net.bigpoint.darkorbit.map.model.traits.clickIcon.factory
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.ClickIconTrait;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.action.DefaultClickIconEntityAction;
   import net.bigpoint.darkorbit.map.model.traits.clickIcon.action.NoneClickIconAction;
   import net.bigpoint.darkorbit.pattern.FullResourcePattern;
   
   public class ClickIconFactory
   {
      
      public static const ACTION_TYPE_NONE:String = "none";
      
      private static const METHOD_MAP:Object = {};
      
      METHOD_MAP[ACTION_TYPE_NONE] = createNoActionIconTrait;
      
      public function ClickIconFactory()
      {
         super();
      }
      
      public static function create(param1:XML, param2:MapEntity) : ClickIconTrait
      {
         var _loc3_:String = param1.@action;
         return METHOD_MAP[_loc3_] ? METHOD_MAP[_loc3_](param1,param2) : createDefault(param1,param2);
      }
      
      private static function createNoActionIconTrait(param1:XML, param2:MapEntity) : ClickIconTrait
      {
         var _loc3_:ClickIconTrait = createClickIconTrait(param1,param2);
         _loc3_.action = new NoneClickIconAction();
         return _loc3_;
      }
      
      private static function createDefault(param1:XML, param2:MapEntity) : ClickIconTrait
      {
         var _loc3_:ClickIconTrait = createClickIconTrait(param1,param2);
         _loc3_.action = new DefaultClickIconEntityAction();
         return _loc3_;
      }
      
      private static function createClickIconTrait(param1:XML, param2:MapEntity) : ClickIconTrait
      {
         return new ClickIconTrait(new FullResourcePattern(0,String(param1.@srcKey),String(param1.@resKey)),int(param1.@radius) || 50,int(param1.@priority),param2.getPivot(String(param1.@pivotId) || "click_icon"));
      }
   }
}

