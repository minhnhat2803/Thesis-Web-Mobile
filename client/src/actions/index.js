import axios from "axios";

const BASE_URL = "http://192.168.1.32:8080/";

export const checkPosition = async () => {
    const res = await axios.get(`${BASE_URL}/scan/position`);
    return res;
};

export const scanImage = async (imageSrc) => {
    const res = await axios.post(`${BASE_URL}scan/`, { imageSrc });
    return res;
};

export const getAllCustomer = async () => {
    const res = await axios.get(`${BASE_URL}users/`);
    return res;
};

export const getCustomerBill = async (userID) => {
    const res = await axios.get(`${BASE_URL}bills/${userID}`);
    return res;
};
