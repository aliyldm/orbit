package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo
{
   import com.bealearts.collection.VectorCollection;
   import spark.collections.Sort;
   
   public class TDMResultWindowTabVo
   {
      
      private static const SORT:Sort = new Sort();
      
      private static const FIELDS:Array = [new TDMPointSort()];
      
      SORT.fields = FIELDS;
      
      private var _factionId:int;
      
      private var _tabLable:String;
      
      private var _content:VectorCollection = new VectorCollection();
      
      public function TDMResultWindowTabVo(param1:String, param2:int, param3:Vector.<TDMResultWindowTabContentVo>)
      {
         super();
         this._factionId = param2;
         this._tabLable = param1;
         this._content.sort = SORT;
         this._content.source = param3;
      }
      
      public function get factionId() : int
      {
         return this._factionId;
      }
      
      public function get tabLable() : String
      {
         return this._tabLable;
      }
      
      public function get contentConllection() : VectorCollection
      {
         return this._content;
      }
   }
}

