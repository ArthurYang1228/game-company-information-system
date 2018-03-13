package models;

import java.sql.* ;
import java.sql.Date;
import java.text.SimpleDateFormat;
import javax.sql.*;
import java.util.*;
import java.lang.Number;
import java.util.ArrayList;  


public class Logistic {
	
	/** the learning rate */
	private double rate;
	/** the weight to learn */
	private double[] weights;
	/** the number of iterations */
	private int ITERATIONS = 3000;
	
	private Connection connection;
	private List<Instance> dataset = new ArrayList<Instance>();;  
	
	public Logistic(int n) {
		try {
			connection = Connector.getConn();
		
			Statement st= connection.createStatement(); 
			String sql = "SELECT calls,success FROM logistic;";
			ResultSet rs=st.executeQuery(sql); 

			while (rs.next()){
			    int[] data = new int[n+1];
			    data[0] = 1;
			    data[1] = rs.getInt(1);
			    int label = rs.getInt(2);
			    Instance instance = new Instance(label,data);
			    dataset.add(instance);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		this.rate = 0.0001;
		weights = new double[n+1];
		
	}
		
	
	public static double sigmoid(double z) {
		return 1.0 / (1.0 + Math.exp(-z));
	}

	public void train() {
		for (int n=0; n<ITERATIONS; n++) {
			double lik = 0.0;
			for (int i=0; i<dataset.size(); i++) {
				int[] x = dataset.get(i).x;
				double predicted = classify(x);
				int label = dataset.get(i).label;
				for (int j=0; j<weights.length; j++) {
					weights[j] = weights[j] + rate * (label - predicted) * x[j];
				}
				// not necessary for learning
				lik += label * Math.log(classify(x)) + (1-label) * Math.log(1- classify(x));
			}
			//System.out.println("iteration: " + n + " " + Arrays.toString(weights) + " mle: " + lik);
		}
	}

	public double classify(int[] x) {
		double logit = 0.0;
		for (int i=0; i<weights.length;i++)  {
			logit += weights[i] * x[i];
		}
		return sigmoid(logit);
	}

	public static class Instance {
		public int label;
		public int[] x;

		public Instance(int label, int[] x) {
			this.label = label;
			this.x = x;
		}
	}
/*
	public static void main(String... args) throws FileNotFoundException {
		List<Instance> instances = readDataSet("dataset.txt");
		Logistic logistic = new Logistic(5);
		logistic.train(instances);
		int[] x = {2, 1, 1, 0, 1};
		System.out.println("prob(1|x) = " + logistic.classify(x));

		int[] x2 = {1, 0, 1, 0, 0};
		System.out.println("prob(1|x2) = " + logistic.classify(x2));

	}
*/
	
}  